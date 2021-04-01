package uk.gov.hmrc.test.api.requests

import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.BaseUris

object InterestForecastingRequests extends BaseRequests with BaseUris {

  def getDebtCalculation(json: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(enrolments = Seq("read:interest-forecasting"))
    val baseUri     = s"$interestForecostingApiUrl/debt-calculation"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.post(baseUri, headers = headers, Json.parse(json))
  }

  def getBodyAsString(variant: String): String =
    TestData.loadedFiles(variant)

  def createDebtCalculationRule(): StandaloneWSResponse = {
    val bearerToken = createBearerToken(enrolments = Seq("read:interest-forecasting"))
    val baseUri     = s"$interestForecostingApiUrl/settings"
    val rule="{\"settings\": \"IF regime == 'DRIER' AND chargeType == 'NI' -> intRate = 3% OTHERWISE -> intRate = 0%\"}"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.post(baseUri, headers = headers,Json.parse(rule ))
  }
}
