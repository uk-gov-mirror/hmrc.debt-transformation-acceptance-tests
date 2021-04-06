package uk.gov.hmrc.test.api.requests

import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.requests.InterestForecastingRequests.{createBearerToken, interestForecostingApiUrl}

object Helper {

  def createDebtCalculationRule(): StandaloneWSResponse = {
    val bearerToken = createBearerToken(enrolments = Seq("read:interest-forecasting"))
    val baseUri     = s"$interestForecostingApiUrl/settings"
    val rule="{\"settings\": \"IF regime == 'DRIER' AND chargeType == 'NI' -> intRate = 1% OTHERWISE -> intRate = 0%\"}"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.post(baseUri, headers = headers,Json.parse(rule))
  }


}
