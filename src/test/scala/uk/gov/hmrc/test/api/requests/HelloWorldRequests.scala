package uk.gov.hmrc.test.api.requests

import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.{BaseRequests, BaseUris}

object HelloWorldRequests extends BaseRequests with BaseUris {

  def getTimeToPayProxy(endpoint: String): StandaloneWSResponse = {
    val baseUri     = s"$timeToPayProxyApiUrl$endpoint"
    WsClient.get(baseUri, headers = Map())
  }

}
