package uk.gov.hmrc.test.api.requests

import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.{BaseRequests, RandomValues, TestData}

object StatementOfLiabilityRequests extends BaseRequests with RandomValues {

  val bearerToken = createBearerToken(enrolments = Seq("read:statement-of-liability"))

  def getStatementOfLiability(json: String): StandaloneWSResponse = {
    val baseUri = s"$statementOfLiabilityApiUrl/sol"
    val headers = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.post(baseUri, headers = headers, Json.parse(json))
  }

  //Used by hello world only
  def getStatementLiabilityHelloWorld(endpoint: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(enrolments = Seq("read:statement-of-liability"))
    val baseUri     = s"$statementOfLiabilityApiUrl$endpoint"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.get(baseUri, headers = headers)
  }

  def getBodyAsString(variant: String): String =
    TestData.loadedFiles(variant)

}
