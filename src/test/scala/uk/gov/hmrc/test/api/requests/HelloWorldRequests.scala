package uk.gov.hmrc.test.api.requests

import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.BaseUris

object HelloWorldRequests extends BaseRequests with BaseUris {

  def getStatementLiabilityService(endpoint: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(enrolments = Seq("read:statement-of-liability"))
    val baseUri     = s"$statementOfLiabilityApiUrl$endpoint"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.get(baseUri, headers = headers)
  }

  def getInterestForecastingService(endpoint: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(enrolments = Seq("read:interest-forecasting"))
    val baseUri     = s"$interestForecostingApiUrl$endpoint"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.get(baseUri, headers = headers)
  }

  def getTimeToPayProxy(endpoint: String): StandaloneWSResponse = {
    val baseUri     = s"$statementOfLiabilityApiUrl$endpoint"
    val headers     = Map(
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.get(baseUri, headers = headers)
  }

}
