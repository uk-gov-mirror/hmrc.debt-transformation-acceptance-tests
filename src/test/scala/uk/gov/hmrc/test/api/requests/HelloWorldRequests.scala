package uk.gov.hmrc.test.api.requests

import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.{BaseRequests, BaseUris}

object HelloWorldRequests extends BaseRequests with BaseUris {
  val bearerToken = createBearerToken(enrolments = Seq("read:time-to-pay-proxy"))

  def baseCall(endpoint: String, maybeBearerToken: Option[String]) = {
    val baseUri     = s"$timeToPayProxyApiUrl$endpoint"
    val headers     = maybeBearerToken.fold[Map[String, String]](Map())(bearerToken => Map(
      "Authorization" -> s"Bearer $bearerToken"))
    WsClient.get(baseUri, headers = headers)
  }
  def getTimeToPayProxy(endpoint: String): StandaloneWSResponse = {
    baseCall(endpoint, Some(bearerToken))
  }

  def getTimeToPayProxyWithoutBearerToken(endpoint: String): StandaloneWSResponse = {
    baseCall(endpoint, None)
  }

}
