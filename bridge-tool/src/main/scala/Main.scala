// TODO:
// * Handle error cases; respond with HTTP errors, log connectivity errors
// * Request new token after timeout (4 hours?)
// * Logging??
// * Refactor: classes; packages;
package main

import io.circe._
import io.circe.generic.auto._
import io.circe.parser._
import io.circe.syntax._
import java.time.LocalDateTime

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

  def authBearerToken = requests.RequestAuth.Bearer(`access_token`)

}

val defaultHeaders = Map("Content-Type" -> "application/json")

val externalTestTokenURL = "https://test-api.service.hmrc.gov.uk/oauth/token"
val qaTokenURL = "https://api.qa.tax.service.gov.uk/oauth/token"

val externalTestTokenParams = Map(
  "client_secret" -> "a3438df2-c78a-4926-92b5-bc50382e6d0c",
  "client_id" -> "IRSzWvRL34nBwQqhKVV8ACzchThp",
  "grant_type" -> "client_credentials",
  "scope" -> "read:time-to-pay-proxy"
)

val qaTokenParams = Map(
  "client_secret" -> "6c2fc716-b9c6-4bb8-a57e-4908d32b9b27",
  "client_id" -> "reRg5ZSks9hGLpzxS5RRnYHjHYtW",
  "grant_type" -> "client_credentials",
  "scope" -> "read:debt-management-api"
)

val externalTestTTPURL = "https://test-api.service.hmrc.gov.uk/individuals/time-to-pay-proxy/"
// TODO Change name of qaTTPURL
val qaTTPURL = "https://api.qa.tax.service.gov.uk"

val externalTestsRequestsURL = s"${externalTestTTPURL}test-only/requests"
val externalTestsResponseURL = s"${externalTestTTPURL}test-only/response"

def retrieveAccessToken(url: String, data: Map[String, String]): TokenResponse = {
  val response = requests.post(url, data = data)
  decode[TokenResponse](response.text()).getOrElse { ??? }
}

def retrieveExternalTestToken(): TokenResponse =
  retrieveAccessToken(externalTestTokenURL, externalTestTokenParams)

def retrieveQAToken(): TokenResponse =
  retrieveAccessToken(qaTokenURL, qaTokenParams)

def retriveAllUnprocessedRequests(token: TokenResponse): List[RequestDetail] = {
  val response = requests.get(
    url = externalTestsRequestsURL,
    auth = token.authBearerToken
  )
  decode[List[RequestDetail]](response.text()).getOrElse { ??? }
}

def formatQAURL(path: String): String =
  s"${qaTTPURL}${path}"

def postRequestDetailsToQA(token: TokenResponse, details: RequestDetail): requests.Response = {
  val auth = token.authBearerToken
  val url = details.uri.getOrElse { ??? }
  val method = details.method.getOrElse("POST").trim.toUpperCase
  pprint.pprintln("Posting to QA:")
  pprint.pprintln(details.content)
  requests.send(method).apply(auth = auth, url = formatQAURL(url), data = details.content.noSpaces, headers = defaultHeaders)
}

def postResponseToExternalTest(token: TokenResponse, details: RequestDetail, qaResponse: Json): Int = {
  val responseDetails = RequestDetail(
    isResponse = true,
    requestId = details.requestId,
    content = qaResponse
  )
  requests.post(
    auth = token.authBearerToken,
    url = externalTestsResponseURL,
    data = responseDetails.asJson.noSpaces,
    headers = defaultHeaders
  ).statusCode
}

@scala.annotation.tailrec
def loop(qaToken: TokenResponse, externalTestToken: TokenResponse): Unit = {
  val unprocessed = retriveAllUnprocessedRequests(externalTestToken)

  unprocessed.headOption match {
    case Some(details) =>
      pprint.pprintln("Request found:")
      pprint.pprintln(details)
      println(details)
      val qaResponse = postRequestDetailsToQA(qaToken, details)

      postResponseToExternalTest(externalTestToken, details, decode[Json](qaResponse.text()).getOrElse { ??? })
      loop(qaToken, externalTestToken)

    case None =>
      pprint.pprintln("No requests found... Sleeping")
      Thread.sleep(2000)
      loop(qaToken, externalTestToken)
  }
}

object Main extends App {
  val externalTestToken = retrieveExternalTestToken()
  val qaToken = retrieveQAToken()

  loop(qaToken, externalTestToken)
}
