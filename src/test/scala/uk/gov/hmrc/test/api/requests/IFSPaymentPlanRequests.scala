package uk.gov.hmrc.test.api.requests

import cucumber.api.scala.{EN, ScalaDsl}
import io.cucumber.datatable.DataTable
import java.time.LocalDate
import java.util.Date
import org.joda.time.{DateTime, DateTimeZone}
import org.scalatest.Matchers
import org.scalatest.concurrent.Eventually
import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import play.twirl.api.TwirlHelperImports.twirlJavaCollectionToScala
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.models.{Frequency, PaymentPlan}
import uk.gov.hmrc.test.api.utils.{BaseRequests, ScenarioContext, TestData}

object IFSPaymentPlanRequests extends ScalaDsl with EN with Eventually with Matchers with BaseRequests {

    def createPaymentPlanRequestBody(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }
    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val quoteDate             = dateTime.toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1).toString("yyyy-MM-dd")
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }

    paymentPlan = getBodyAsString("paymentPlan")
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
      .replaceAll("<REPLACE_quoteDate>", quoteDate)
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set("paymentPlan", paymentPlan)
    print("instalment-calculation request json ::::::::::::::::::::::::::::::" + paymentPlan)

  }

  def addDebtChargeItemsToPaymentPlan(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    var debtItemCharges        = ""

    asMapTransposed.zipWithIndex.foreach { case (debtItemCharge, index) =>
      debtItemCharges = debtItemCharges.concat(
        getBodyAsString("debtItemCharge")
                .replaceAll("<REPLACE_debtId>", debtItemCharge.get("debtId"))
                .replaceAll("<REPLACE_debtAmount>", debtItemCharge.get("debtAmount"))
                .replaceAll("<REPLACE_mainTrans>", debtItemCharge.get("mainTrans"))
                .replaceAll("<REPLACE_subTrans>", debtItemCharge.get("subTrans"))
      )

      if (index + 1 < asMapTransposed.size) debtItemCharges = debtItemCharges.concat(",")
    }
    val jsonWithDebtItemCharges = ScenarioContext.get("paymentPlan").toString.replaceAll("<REPLACE_debtItemCharges>", debtItemCharges)
    ScenarioContext.set("paymentPlan", jsonWithDebtItemCharges)
    print("debt Items Charges ::::::::::::::::::::::::::::::" + jsonWithDebtItemCharges)

  }
//  todo add capability for multiple debt item charges
  def createPaymentPlanFrequency(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null

    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }

    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val QuoteDate             = dateTime.plusDays(1).toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.minusDays(1) toString "yyyy-MM-dd"
    val initialPaymentDate    = dateTime.plusDays(1).toString("yyyy-MM-dd")
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("paymentPlan")
      .replaceAll("<REPLACE_debtId>", "debtId")
      .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
      .replaceAll("<REPLACE_quoteDate>", QuoteDate)
      .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
      .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)
      .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("instalment-calculation request json :::::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item charges
  def debtPlanDetailsWithInitailPaymentRequest(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }
    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val quoteDate             = dateTime.toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(129).toString("yyyy-MM-dd")
    val initialPaymentDate    = dateTime.plusDays(129).toString("yyyy-MM-dd")
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("DebtPlanWithInitialPayment")
            .replaceAll("<REPLACE_debtId>", "debtId")
            .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
            .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
            .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
            .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
            .replaceAll("<REPLACE_quoteDate>", quoteDate)
            .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
            .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
            .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
            .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)
            .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("plan with initail payment request json ::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item charges
  def debtInstalmentPaymentPlanRequest(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }
    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val quoteDate             = dateTime.toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1).toString("yyyy-MM-dd")
    val initialPaymentDate    = dateTime.plusDays(1).toString("yyyy-MM-dd")
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("DebtPlanWithInitialPayment")
            .replaceAll("<REPLACE_debtId>", "debtId")
            .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
            .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
            .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
            .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
            .replaceAll("<REPLACE_quoteDate>", quoteDate)
            .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
            .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
            .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
            .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)
            .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("plan with initail payment request json ::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item charges
  def frequencyPlanWithQuoteDateInPast(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }

    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val QuoteDate             = dateTime.minusDays(1).toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1) toString "yyyy-MM-dd"
    val initialPaymentDate    = dateTime.plusDays(1).toString("yyyy-MM-dd")
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("paymentPlan")
            .replaceAll("<REPLACE_debtId>", "debtId")
            .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
            .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
            .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
            .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
            .replaceAll("<REPLACE_quoteDate>", QuoteDate)
            .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
            .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
            .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
            .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)
            .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("instalment-calculation request json :::::::::::::::::::::::::::::::::" + paymentPlan)
  }

  def getNextInstalmentDateByFrequency(paymentPlan: PaymentPlan, iterateVal: Int): LocalDate = {
    val frequency = paymentPlan.paymentFrequency.entryName
    frequency match {
      case Frequency.Single.entryName     => paymentPlan.instalmentPaymentDate.plusDays(iterateVal)
      case Frequency.Weekly.entryName     => paymentPlan.instalmentPaymentDate.plusWeeks(iterateVal)
      case Frequency.BiWeekly.entryName   => paymentPlan.instalmentPaymentDate.plusWeeks(iterateVal * 2)
      case Frequency.FourWeekly.entryName => paymentPlan.instalmentPaymentDate.plusWeeks(iterateVal * 4)
      case Frequency.Monthly.entryName    => paymentPlan.instalmentPaymentDate.plusMonths(iterateVal)
      case Frequency.Quarterly.entryName  => paymentPlan.instalmentPaymentDate.plusMonths(iterateVal * 3)
      case Frequency.HalfYearly.entryName => paymentPlan.instalmentPaymentDate.plusMonths(iterateVal * 6)
      case Frequency.Annually.entryName   => paymentPlan.instalmentPaymentDate.plusYears(iterateVal)
    }
  }

  def getPaymentPlan(json: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(
      enrolments = Seq("read:interest-forecasting"),
      userType = getRandomAffinityGroup,
      utr = "123456789012"
    )
    val baseUri     = s"$interestForecostingApiUrl/instalment-calculation"

    val headers = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    print("instalment-calculation baseUri ********************" + baseUri)
    WsClient.post(baseUri, headers = headers, Json.parse(json))
  }

//  todo add capability for multiple debt item charges
  def initialPaymentDateAfterInstalmentDate(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }
    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val quoteDate             = dateTime.toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1).toString("yyyy-MM-dd")
    val initialPaymentDate    = dateTime.plusDays(5).toString("yyyy-MM-dd")
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("DebtPlanWithInitialPayment")
      .replaceAll("<REPLACE_debtId>", "debtId")
      .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
      .replaceAll("<REPLACE_quoteDate>", quoteDate)
      .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
      .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)
      .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("plan with initail payment request json ::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item charges
  def instalmentPlanWithNoInitialPaymentDate(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }

    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val quoteDate             = dateTime.toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1) toString "yyyy-MM-dd"
    val initialPaymentDate    = dateTime

    var periodEnd = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("noInitialPaymentDate")
      .replaceAll("<REPLACE_debtId>", "debtId")
      .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
      .replaceAll("<REPLACE_quoteDate>", quoteDate)
      .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
      .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set("paymentPlan", paymentPlan)
    print("instalment-calculation request json :::::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item charges
  def noInitialPaymentDate(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }

    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val QuoteDate             = dateTime.toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1) toString "yyyy-MM-dd"
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("noInitialPaymentDate")
      .replaceAll("<REPLACE_debtId>", "debtId")
      .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
      .replaceAll("<REPLACE_quoteDate>", QuoteDate)
      .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
      .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("instalment-calculation request json :::::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item charges
  def noInitialPaymentAmount(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null

    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }

    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val QuoteDate             = dateTime.toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1) toString "yyyy-MM-dd"
    val initialPaymentDate    = dateTime.plusDays(1).toString("yyyy-MM-dd")
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("noInitialPaymentAmount")
      .replaceAll("<REPLACE_debtId>", "debtId")
      .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
      .replaceAll("<REPLACE_quoteDate>", QuoteDate)
      .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
      .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("instalment-calculation request json :::::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item charges
  def noInstalmentDate(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }

    val dateTime           = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val quoteDate          = dateTime.toString("yyyy-MM-dd")
    val initialPaymentDate = dateTime.plusDays(1).toString("yyyy-MM-dd")

    var periodEnd = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("paymentPlan")
      .replaceAll("<REPLACE_debtId>", "debtId")
      .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_quoteDate>", quoteDate)
      .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
      .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))
      .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("instalment-calculation request json :::::::::::::::::::::::::::::::::" + paymentPlan)
  }

//  todo add capability for multiple debt item chargs
  def noQuoteDate(dataTable: DataTable): Unit = {
    val asmapTransposed     = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem           = false
    var paymentPlan: String = null
    try ScenarioContext.get("paymentPlan")
    catch { case e: Exception => firstItem = true }

    val dateTime              = new DateTime(new Date()).withZone(DateTimeZone.UTC)
    val initialPaymentDate    = dateTime.plusDays(1).toString("yyyy-MM-dd")
    val instalmentPaymentDate = dateTime.plusDays(1) toString "yyyy-MM-dd"
    var periodEnd             = ""
    if (asmapTransposed.toString.contains("periodEnd")) {
      periodEnd = "\"periodEnd\": \"" + asmapTransposed.get("periodEnd") + "\","
    } else { periodEnd = "" }
    paymentPlan = getBodyAsString("paymentPlan")
      .replaceAll("<REPLACE_debtId>", "debtId")
      .replaceAll("<REPLACE_debtAmount>", asmapTransposed.get("debtAmount"))
      .replaceAll("<REPLACE_instalmentAmount>", asmapTransposed.get("instalmentPaymentAmount"))
      .replaceAll("<REPLACE_paymentFrequency>", asmapTransposed.get("paymentFrequency"))
      .replaceAll("<REPLACE_instalmentDate>", instalmentPaymentDate)
      .replaceAll("<REPLACE_mainTrans>", asmapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asmapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_interestCallDueTotal>", asmapTransposed.get("interestCallDueTotal"))
      .replaceAll("<REPLACE_initialPaymentAmount>", asmapTransposed.get("initialPaymentAmount"))
      .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)

    if (firstItem == true) { paymentPlan = paymentPlan }
    else { paymentPlan = ScenarioContext.get("paymentPlan").toString.concat(",").concat(paymentPlan) }

    ScenarioContext.set(
      "paymentPlan",
      paymentPlan
    )
    print("instalment-calculation request json :::::::::::::::::::::::::::::::::" + paymentPlan)
  }

  def noInstalmentDate() {
    ScenarioContext.set(
      "paymentPlan",
      getBodyAsString("InitialPaymentNoDate")
        .replaceAllLiterally("<REPLACE_initialPaymentDate>", ScenarioContext.get("paymentPlan"))
    )
    ScenarioContext.set(
      "paymentPlan",
      ScenarioContext.get("paymentPlan").toString.replaceAll("<REPLACE_initialPaymentDate>", "")
    )
  }


  def getBodyAsString(variant: String): String =
    TestData.loadedIFSPaymentPlanFiles(variant)

}
