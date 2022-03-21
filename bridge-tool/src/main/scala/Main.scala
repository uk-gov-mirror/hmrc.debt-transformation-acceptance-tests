// TODO:
// * Handle error cases; respond with HTTP errors, log connectivity errors
// * Request new token after timeout (4 hours?)
// * Logging??
// * Refactor: classes; packages;
// * Delete processed requests
package main

import io.circe._
import io.circe.generic.auto._
import io.circe.parser._
import io.circe.syntax._
import java.time.LocalDateTime
import errors.BridgeToolError
import errors.BridgeToolError.Result

final case class RequestDetail(
  requestId: String,
  content: Json,
  isResponse: Boolean,
  uri: Option[String] = None,
  createdOn: Option[LocalDateTime] = None,
  method: Option[String] = None,
  status: Option[Int] = None
)

final case class TokenResponse(`access_token`: String) {
  def authBearerToken: requests.RequestAuth =
    requests.RequestAuth.Bearer(`access_token`)
}

val defaultHeaders = Map("Content-Type" -> "application/json")

val externalTestTokenURL = "https://test-api.service.hmrc.gov.uk/oauth/token"
val qaTokenURL = "https://api.qa.tax.service.gov.uk/oauth/token"

val externalTestTokenParams = Map(
  "client_secret" -> "a3438df2-c78a-4926-92b5-bc50382e6d0c",
  "client_id"     -> "IRSzWvRL34nBwQqhKVV8ACzchThp",
  "grant_type"    -> "client_credentials",
  "scope"         -> "read:time-to-pay-proxy"
)

val qaTokenParams = Map(
  "client_secret" -> "6c2fc716-b9c6-4bb8-a57e-4908d32b9b27",
  "client_id"     -> "reRg5ZSks9hGLpzxS5RRnYHjHYtW",
  "grant_type"    -> "client_credentials",
  "scope"         -> "read:debt-management-api"
)

val externalTestTTPURL = "https://test-api.service.hmrc.gov.uk/individuals/time-to-pay-proxy/"
val qaAPIURL = "https://api.qa.tax.service.gov.uk"

val externalTestsRequestsURL = s"${externalTestTTPURL}test-only/requests"
val externalTestsResponseURL = s"${externalTestTTPURL}test-only/response"
def externalTestDeleteURL(id: String): String =
  s"${externalTestTTPURL}test-only/request/${id}"

def retrieveAccessToken(url: String, data: Map[String, String]): Result[TokenResponse] = {
  val response = requests.post(url, data = data)
  decode[TokenResponse](response.text()).left.map { error =>
    BridgeToolError.Decode(response.text(), error)
  }
}

def retrieveExternalTestToken(): Result[TokenResponse] =
  retrieveAccessToken(externalTestTokenURL, externalTestTokenParams)

def retrieveQAToken(): Result[TokenResponse] =
  retrieveAccessToken(qaTokenURL, qaTokenParams)

def retriveAllUnprocessedRequests(token: TokenResponse): Result[List[RequestDetail]] = {
  val response = requests.get(
    url = externalTestsRequestsURL,
    auth = token.authBearerToken
  )
  decode[List[RequestDetail]](response.text()).left.map { error =>
    BridgeToolError.Decode(response.text(), error)
  }
}

def extractURL(details: RequestDetail): Result[String] =
  details.uri
    .toRight {
      BridgeToolError.MissingURL(details)
    }
    .map(path => s"$qaAPIURL$path")

def extractMethod(details: RequestDetail): Result[String] =
  details.method.map(_.trim.toUpperCase) match {
    case Some("POST") => Right("POST")
    case Some("PUT")  => Right("PUT")
    case Some("GET")  => Right("GET")
    case None         => Right("POST")
    case invalid      => Left(BridgeToolError.BadMethod(details))
  }

def postRequestDetailsToQA(token: TokenResponse, details: RequestDetail): Result[requests.Response] =
  for {
    url    <- extractURL(details)
    method <- extractMethod(details)
  } yield requests
    .send(method)
    .apply(
      auth = token.authBearerToken,
      url = url,
      data = details.content.noSpaces,
      headers = defaultHeaders
    )

def postResponseToExternalTest(token: TokenResponse, details: RequestDetail, qaResponse: Json): Int = {
  val responseDetails = RequestDetail(
    isResponse = true,
    requestId = details.requestId,
    content = qaResponse
  )
  requests
    .post(
      auth = token.authBearerToken,
      url = externalTestsResponseURL,
      data = responseDetails.asJson.noSpaces,
      headers = defaultHeaders
    )
    .statusCode
}

def parseQAResponse(response: requests.Response): Result[Json] =
  parse(response.text()).left.map { error =>
    BridgeToolError.Decode(response.text(), error),
  }

def nextProcessableRequest(details: List[RequestDetail]): Result[RequestDetail] =
  details.headOption.toRight(BridgeToolError.NoRequestsToProcess)

def deleteRequest(token: TokenResponse, details: RequestDetail): Result[Unit] =
  requests.delete(
    url = externalTestDeleteURL(details.requestId),
    auth = token.authBearerToken
  ).statusCode match {
    case ok if ok < 300 && ok >= 200 => Right(())
    case _ => Left(???)
  }

def process(qaToken: TokenResponse, externalTestToken: TokenResponse): Result[Unit] =
  for {
    requests        <- retriveAllUnprocessedRequests(externalTestToken)
    details         <- nextProcessableRequest(requests)
    qaResponse      <- postRequestDetailsToQA(qaToken, details)
    responseContent <- parseQAResponse(qaResponse)
  } yield postResponseToExternalTest(externalTestToken, details, responseContent)

@scala.annotation.tailrec
def loop(qaToken: TokenResponse, externalTestToken: TokenResponse): Unit =
  process(qaToken, externalTestToken) match {

    case Right(()) =>
      loop(qaToken, externalTestToken)

    case Left(BridgeToolError.NoRequestsToProcess) =>
      logging.info("Haven't found any requests to process right now. Sleeping..")
      Thread.sleep(2000)
      loop(qaToken, externalTestToken)

    case Left(error) =>
      logging.error("Failed to process request;")
      logging.error(error.errorMessage)

      Thread.sleep(2000)
      loop(qaToken, externalTestToken)

  }

object Main extends App {

  for {
    externalTestToken <- retrieveExternalTestToken()
    qaToken           <- retrieveQAToken()
  } yield loop(qaToken, externalTestToken)

}
