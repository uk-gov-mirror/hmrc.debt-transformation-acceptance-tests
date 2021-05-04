package uk.gov.hmrc.test.api.requests

import play.api.Logger.logger
import play.api.libs.json.{JsValue, Json}
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.RandomValues

object RequestSolDetails extends BaseRequests with RandomValues {
  val bearerToken = createBearerToken(enrolments = Seq("read:statement-of-liability"))
  def getStatementOfLiability(variant: String): StandaloneWSResponse = {
    val baseUri     = s"$statementOfLiabilityApiUrl/sol"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    val jsonBody: JsValue = Json.parse(
      getBodyAsString(variant))
//        .replaceAll("<REPLACE_customsDeclarationId>", getRandomDeclarationId)
//        .replaceAll("<REPLACE_sAndSMasterRefNum>", getRandomSAndSMasterRefNum))
    logger.info("creating statement details json")
    WsClient.post(baseUri, headers = headers, jsonBody)
  }

  def getBodyAsString(variant: String): String =
    TestData.loadedFiles(variant)










}
