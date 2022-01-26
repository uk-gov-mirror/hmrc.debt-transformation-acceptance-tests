package uk.gov.hmrc.test.api.requests

import io.cucumber.datatable.DataTable
import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.{BaseRequests, RandomValues, ScenarioContext, TestData}

import scala.collection.convert.ImplicitConversionsToScala.`collection AsScalaIterable`

object FCStatementOfLiabilityRequests extends BaseRequests with RandomValues {

  val bearerToken = createBearerToken(
    enrolments = Seq("read:statement-of-liability"),
    userType = getRandomAffinityGroup,
    utr = "123456789012"
  )

  def getFCStatementOfLiability(json: String): StandaloneWSResponse = {
    val baseUri = s"$statementOfLiabilityApiUrl/fc-sol"
    val headers = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.post(baseUri, headers = headers, Json.parse(json))
  }

  def getBodyAsString(variant: String): String =
    TestData.loadedFiles(variant)

  def fcSolRequest(dataTable: DataTable): Unit = {
    val asMapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var debtDetails: String = null

    try ScenarioContext.get("debtDetails")
    catch {
      case e: Exception => firstItem = true
    }

    val FCSolMultipleDebts = getBodyAsString("FCSolDebt")
      .replaceAll("REPLACE_customerUniqueRef", asMapTransposed.get("customerUniqueRef"))
      .replaceAll("REPLACE_solRequestedDate", asMapTransposed.get("solRequestedDate"))
    if (firstItem == true) {
      debtDetails = FCSolMultipleDebts
    } else {
      debtDetails = ScenarioContext.get("debtDetails").toString.concat(",").concat(FCSolMultipleDebts)
    }

    ScenarioContext.set("debtDetails", debtDetails)
    println(debtDetails)
  }

  def addFCDebts(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    var debtIds         = ""
    asMapTransposed.zipWithIndex.foreach { case (debtId, index) =>
      debtIds = debtIds.concat(
        getBodyAsString("debtId")
          .replaceAll("<REPLACE_debtId>", debtId.get("debtId"))
          .replaceAll("<REPLACE_originalAmount>", debtId.get("originalAmount"))
          .replaceAll("<REPLACE_solDescription>", "solDescription")
          .replaceAll("<REPLACE_interestStartDate>", debtId.get("interestStartDate"))
          .replaceAll("<REPLACE_interestRequestedTo>", debtId.get("interestRequestedTo"))
          .replaceAll("<REPLACE_interestIndicator>", debtId.get("interestIndicator"))
          .replaceAll("<REPLACE_periodEnd>", debtId.get("periodEnd"))
      )
      if (index + 1 < asMapTransposed.size) debtIds = debtIds.concat(",")
    }
    val jsonWithdebtIds = ScenarioContext.get("debtDetails").toString.replaceAll("<REPLACE_debtId>", debtIds)
    ScenarioContext.set("debtDetails", jsonWithdebtIds)
    print("debt with payment history ::::::::::::::::::::::::::::::" + jsonWithdebtIds)
  }

  def addFCSOLPaymentHistory(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    var payments        = ""

    asMapTransposed.zipWithIndex.foreach { case (payment, index) =>
      payments = payments.concat(
        getBodyAsString("payment")
          .replaceAll("<REPLACE_paymentAmount>", payment.get("paymentAmount"))
          .replaceAll("<REPLACE_paymentDate>", payment.get("paymentDate"))
      )

      if (index + 1 < asMapTransposed.size) payments = payments.concat(",")
    }
    val jsonWithPayments = ScenarioContext.get("debtDetails").toString.replaceAll("<REPLACE_payments>", payments)
    ScenarioContext.set("debtDetails", jsonWithPayments)
    print("debt with payment history ::::::::::::::::::::::::::::::" + jsonWithPayments)
  }

  def FCSolWithNoPaymentHistory(): Unit =
    ScenarioContext.set("debtDetails", ScenarioContext.get("debtDetails").toString.replaceAll("<REPLACE_payments>", ""))

  def FCSolWithNoDebts(): Unit =
    ScenarioContext.set("debtDetails", ScenarioContext.get("debtDetails").toString.replaceAll("<REPLACE_debtId>", ""))

}
