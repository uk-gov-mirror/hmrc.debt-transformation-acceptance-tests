package uk.gov.hmrc.test.api.requests

import io.cucumber.datatable.DataTable
import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import java.time.LocalDate
import play.twirl.api.TwirlHelperImports.twirlJavaCollectionToScala
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.{BaseRequests, BaseUris, ScenarioContext, TestData}

import scala.util.Try

object TimeToPayProxyRequests extends BaseRequests with BaseUris {

  val BearerToken = createBearerToken(
    enrolments = Seq("read:time-to-pay-proxy"),
    userType = getRandomAffinityGroup,
    utr = "123456789012"
  )

  def baseCall(endpoint: String, maybeBearerToken: Option[String]) = {
    val baseUri = s"$timeToPayProxyApiUrl$endpoint"
    val headers =
      maybeBearerToken.fold[Map[String, String]](Map())(bearerToken => Map("Authorization" -> s"Bearer $BearerToken"))
    WsClient.get(baseUri, headers = headers)
  }

  private def getBodyAsString(variant: String): String =
    TestData.loadedTtppFiles(variant)

  def addPlan(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    val planData        = asMapTransposed.zipWithIndex.head
    val (plan, _)       = planData
    val replacedPlan    = getBodyAsString("plan")
      .replaceAll("<REPLACE_quoteType>", plan.get("quoteType"))
      .replaceAll("<REPLACE_quoteDate>", plan.get("quoteDate"))
      .replaceAll("<REPLACE_instalmentStartDate>", plan.get("instalmentStartDate"))
      .replaceAll("<REPLACE_instalmentAmount>", plan.get("instalmentAmount"))
      .replaceAll("<REPLACE_frequency>", plan.get("frequency"))
      .replaceAll("<REPLACE_duration>", plan.get("duration"))
      .replaceAll("<REPLACE_initialPaymentAmount>", plan.get("initialPaymentAmount"))
      .replaceAll("<REPLACE_initialPaymentDate>", plan.get("initialPaymentDate"))
      .replaceAll("<REPLACE_paymentPlanType>", plan.get("paymentPlanType"))

    Try(ScenarioContext.get[String]("plan")).fold(
      _ => ScenarioContext.set("plan", replacedPlan),
      _ => ()
    )

    val jsonWithCustomerPlan =
      ScenarioContext.get("generateQuoteRequest").toString.replaceAll("<REPLACE_plan>", replacedPlan)
    ScenarioContext.set("jsonWithCustomerPlan", jsonWithCustomerPlan)
  }

  def planDetails(dataTable: DataTable): Unit = {
    val asMapTransposed     = dataTable.asMaps(classOf[String], classOf[String])
    val planData            = asMapTransposed.zipWithIndex.head
    val (plan, _)           = planData
    var quoteDate           = LocalDate.now().toString
    var instalmentStartDate = LocalDate.now().plusDays(1).toString
    var initialPaymentDate  = LocalDate.now().plusDays(1).toString

    if (planData.toString.contains("quoteDate")) quoteDate = plan.get("quoteDate")
    if (planData.toString.contains("instalmentStartDate")) instalmentStartDate = plan.get("instalmentStartDate")
    if (planData.toString.contains("initialPaymentDate")) initialPaymentDate = plan.get("initialPaymentDate")

    val quoteId             = if (planData.toString().contains("quoteId=")) plan.get("quoteId") else "quoteId1234"
    val instalmentAmount    = if (planData.toString.contains("instalmentAmount=")) plan.get("instalmentAmount") else "100"
    val paymentPlanType     =
      if (planData.toString.contains("paymentPlanType=")) plan.get("paymentPlanType") else "timeToPay"
    val thirdPartyBank      = if (planData.toString.contains("thirdPartyBank=")) plan.get("thirdPartyBank") else "true"
    val numberOfInstalments =
      if (planData.toString.contains("numberOfInstalments=")) plan.get("numberOfInstalments") else "12"
    val totalDebtIncInt     = if (planData.toString.contains("totalDebtIncInt=")) plan.get("totalDebtIncInt") else "10"
    val totalInterest       = if (planData.toString.contains("totalInterest=")) plan.get("totalInterest") else "10"
    val interestAccrued     = if (planData.toString.contains("interestAccrued=")) plan.get("interestAccrued") else "10"
    val planInterest        = if (planData.toString.contains("planInterest=")) plan.get("planInterest") else "10"
    val frequency           = if (planData.toString.contains("frequency=")) plan.get("frequency") else "annually"
    val duration            = if (planData.toString.contains("duration=")) plan.get("duration") else "12"

    val replacedPlanDetails = getBodyAsString("planDetails")
      .replaceAll("<REPLACE_quoteId>", quoteId)
      .replaceAll("<REPLACE_quoteType>", plan.get("quoteType"))
      .replaceAll("<REPLACE_quoteDate>", quoteDate)
      .replaceAll("<REPLACE_instalmentStartDate>", instalmentStartDate)
      .replaceAll("<REPLACE_instalmentAmount>", instalmentAmount)
      .replaceAll("<REPLACE_paymentPlanType>", paymentPlanType)
      .replaceAll("<REPLACE_thirdPartyBank>", thirdPartyBank)
      .replaceAll("<REPLACE_numberOfInstalments>", numberOfInstalments)
      .replaceAll("<REPLACE_frequency>", frequency)
      .replaceAll("<REPLACE_duration>", duration)
      .replaceAll("<REPLACE_initialPaymentDate>", initialPaymentDate)
      .replaceAll("<REPLACE_initialPaymentAmount>", instalmentAmount)
      .replaceAll("<REPLACE_totalDebtIncInt>", totalDebtIncInt)
      .replaceAll("<REPLACE_totalInterest>", totalInterest)
      .replaceAll("<REPLACE_interestAccrued>", interestAccrued)
      .replaceAll("<REPLACE_planInterest>", planInterest)

    Try(ScenarioContext.get[String]("planDetails")).fold(
      _ => ScenarioContext.set("planDetails", replacedPlanDetails),
      _ => ()
    )
    val jsonWithCustomerPlan =
      ScenarioContext.get("generateQuoteRequest").toString.replaceAll("<REPLACE_plan>", replacedPlanDetails)
    ScenarioContext.set("jsonWithCustomerPlan", jsonWithCustomerPlan)
  }

  def addPostCodeDetails(dataTable: DataTable): Unit = {
    val asMapTransposed               = dataTable.asMaps(classOf[String], classOf[String])
    var customerPostCodes             = ""
    asMapTransposed.zipWithIndex.foreach { case (postCode, index) =>
      customerPostCodes = customerPostCodes.concat(
        getBodyAsString("postCodes")
          .replaceAll("<REPLACE_addressPostcode>", postCode.get("addressPostcode"))
          .replaceAll("<REPLACE_postcodeDate>", postCode.get("postcodeDate"))
      )
      if (index + 1 < asMapTransposed.size) customerPostCodes = customerPostCodes.concat(",")
    }
    val jsonWithCustomerPlanPostCodes =
      ScenarioContext.get("jsonWithCustomerPlan").toString.replaceAll("<REPLACE_customerPostCodes>", customerPostCodes)
    ScenarioContext.set("debtItems", jsonWithCustomerPlanPostCodes)
  }

  def addDebtPaymentHistory(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    var payments        = ""

    asMapTransposed.zipWithIndex.foreach { case (payment, index) =>
      payments = payments.concat(
        getBodyAsString("paymentHistory")
          .replaceAll("<REPLACE_paymentAmount>", payment.get("paymentAmount"))
          .replaceAll("<REPLACE_paymentDate>", payment.get("paymentDate"))
      )

      if (index + 1 < asMapTransposed.size) payments = payments.concat(",")
    }
    val jsonWithPayments = ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_paymentHistory>", payments)
    ScenarioContext.set("debtItems", jsonWithPayments)
  }

  def addPaymentMethod(dataTable: DataTable): Unit = {
    val asMapTransposed               = dataTable.asMaps(classOf[String], classOf[String])
    var paymentMethod                 = ""
    asMapTransposed.zipWithIndex.foreach { case (postCode, index) =>
      paymentMethod = paymentMethod.concat(
        getBodyAsString("paymentMethods")
          .replaceAll("<REPLACE_paymentMethod>", postCode.get("paymentMethod"))
          .replaceAll("<REPLACE_paymentReference>", postCode.get("paymentReference"))
      )
      if (index + 1 < asMapTransposed.size) paymentMethod = paymentMethod.concat(",")
    }
    val jsonWithCustomerPlanPostCodes =
      ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_payments>", paymentMethod)
    ScenarioContext.set("debtItems", jsonWithCustomerPlanPostCodes)
  }

  def addAddressDetails(dataTable: DataTable): Unit = {
    val asMapTransposed   = dataTable.asMaps(classOf[String], classOf[String])
    var customerPostCodes = ""

    asMapTransposed.zipWithIndex.foreach { case (postCode, index) =>
      customerPostCodes = customerPostCodes.concat(
        getBodyAsString("postCodes")
          .replaceAll("<REPLACE_addressPostcode>", postCode.get("addressPostcode"))
          .replaceAll("<REPLACE_postcodeDate>", postCode.get("postcodeDate"))
      )
      if (index + 1 < asMapTransposed.size) customerPostCodes = customerPostCodes.concat(",")
    }
    val jsonWithCustomerPlanAddress =
      ScenarioContext.get("jsonWithCustomerPlan").toString.replaceAll("<REPLACE_customerPostCodes>", customerPostCodes)
    ScenarioContext.set("debtItems", jsonWithCustomerPlanAddress)
  }

  def addDebtItem(dataTable: DataTable): Unit = {
    val asMapTransposed                           =
      dataTable.transpose().asMap(classOf[String], classOf[String])
    val replaceDebtItem                           = getBodyAsString("debtItems")
      .replaceAll("<REPLACE_debtItemChargeId>", asMapTransposed.get("debtItemChargeId"))
      .replaceAll("<REPLACE_mainTrans>", asMapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asMapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_originalDebtAmount>", asMapTransposed.get("originalDebtAmount"))
      .replaceAll("<REPLACE_interestStartDate>", asMapTransposed.get("interestStartDate"))
    ScenarioContext.set("currentDebtItem", replaceDebtItem)
    val jsonWithCustomerDebtPaymentHistoryDetails =
      ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_debtItems>", replaceDebtItem)
    ScenarioContext.set("debtItems", jsonWithCustomerDebtPaymentHistoryDetails)
  }

  def debtItem(dataTable: DataTable): Unit = {
    val asMapTransposed                           =
      dataTable.transpose().asMap(classOf[String], classOf[String])
    val replaceDebtItem                           = getBodyAsString("debtItemsWithNoInterestStartDate")
      .replaceAll("<REPLACE_debtItemChargeId>", asMapTransposed.get("debtItemChargeId"))
      .replaceAll("<REPLACE_mainTrans>", asMapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asMapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_originalDebtAmount>", asMapTransposed.get("originalDebtAmount"))
    ScenarioContext.set("currentDebtItem", replaceDebtItem)
    val jsonWithCustomerDebtPaymentHistoryDetails =
      ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_debtItems>", replaceDebtItem)
    ScenarioContext.set("debtItems", jsonWithCustomerDebtPaymentHistoryDetails)
  }

  def addInstalments(dataTable: DataTable): Unit = {
    val asMapTransposed    =
      dataTable.transpose().asMap(classOf[String], classOf[String])
    val replacedInstalment = getBodyAsString("instalment")
      .replaceAll("<REPLACE_debtItemChargeId>", asMapTransposed.get("debtItemChargeId"))
      .replaceAll("<REPLACE_debtItemId>", asMapTransposed.get("debtItemId"))
      .replaceAll("<REPLACE_dueDate>", asMapTransposed.get("dueDate"))
      .replaceAll("<REPLACE_amountDue>", asMapTransposed.get("amountDue"))
      .replaceAll("<REPLACE_expectedPayment>", asMapTransposed.get("expectedPayment"))
      .replaceAll("<REPLACE_interestRate>", asMapTransposed.get("interestRate"))
      .replaceAll("<REPLACE_instalmentNumber>", asMapTransposed.get("instalmentNumber"))
      .replaceAll("<REPLACE_instalmentInterestAccrued>", asMapTransposed.get("instalmentInterestAccrued"))
      .replaceAll("<REPLACE_instalmentBalance>", asMapTransposed.get("instalmentBalance"))

    val debtRepaymentPlanJson =
      ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_instalments>", replacedInstalment)
    ScenarioContext.set("debtItems", debtRepaymentPlanJson)
    print(s"full debt repayment plan details json *********************************   $debtRepaymentPlanJson")

  }

  def addBreathingSpaces(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])

    val breathingSpaces =
      asMapTransposed.zipWithIndex.foldLeft[String]("") { (acc, current) =>
        val (breathingSpace, index) = current
        val replaced                = getBodyAsString("breathingSpace")
          .replaceAll("<REPLACE_debtRespiteFrom>", breathingSpace.get("debtRespiteFrom"))
          .replaceAll("<REPLACE_debtRespiteTo>", breathingSpace.get("debtRespiteTo"))
        if (index + 1 < asMapTransposed.size)
          s"$acc$replaced,"
        else
          s"$acc$replaced"
      }

    val currentDuty = ScenarioContext
      .get("currentDuty")
      .toString
      .replaceAll("<REPLACE_breathingSpaces>", breathingSpaces)
    ScenarioContext.set("currentDuty", currentDuty)

  }

  def addPayments(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])

    val payments                          = asMapTransposed.zipWithIndex.foldLeft[String]("") { (acc, current) =>
      val (payment, index) = current

      val paymentReplaced = getBodyAsString("paymentHistory")
        .replaceAll("<REPLACE_paymentDate>", payment.get("paymentDate"))
        .replaceAll("<REPLACE_paymentAmount>", payment.get("paymentAmount"))

      if (index + 1 < asMapTransposed.size)
        s"$acc$paymentReplaced,"
      else
        s"$acc$paymentReplaced"
    }
    val jsonWithDebtPaymentHistoryDetails =
      ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_paymentHistory>", payments)
    ScenarioContext.set("debtItems", jsonWithDebtPaymentHistoryDetails)
    print("customer debt Plan json ::::::::::::::::::::::::::::::::::::" + jsonWithDebtPaymentHistoryDetails)

  }

  def addInstalmentToCreatePlanRequest(): Unit = {

    val currentCreatePlanRequest =
      ScenarioContext.get[String]("createPlanRequest")
    val currentInstalments       =
      Try(ScenarioContext.get[String]("instalments"))
        .fold(_ => "", identity)
    val createPlanRequest        =
      currentCreatePlanRequest.replace("<REPLACE_instalments>", currentInstalments)
    ScenarioContext.set("createPlanRequest", createPlanRequest)
  }

  def addAdHocsToGenerateQuoteRequest(): Unit = {

    val currentGenerateQuoteRequest =
      ScenarioContext.get[String]("generateQuoteRequest")
    val currentAdHocs               =
      Try(ScenarioContext.get[String]("adHocs"))
        .fold(_ => "", identity)
    val generateQuoteRequest        =
      currentGenerateQuoteRequest.replace("<REPLACE_adHocs>", currentAdHocs)
    ScenarioContext.set("generateQuoteRequest", generateQuoteRequest)
  }

  def addCustomersToGenerateQuoteRequest(): Unit = {

    val currentGenerateQuoteRequest =
      ScenarioContext.get[String]("generateQuoteRequest")
    val currentCustomers            =
      Try(ScenarioContext.get[String]("customers"))
        .fold(_ => "", identity)
    val generateQuoteRequest        =
      currentGenerateQuoteRequest.replace(
        "<REPLACE_customer>",
        currentCustomers
      )
    ScenarioContext.set("generateQuoteRequest", generateQuoteRequest)
  }

  private def addPreviousDutyToDuties(): Unit = {
    val maybeCurrentDuties: Option[String] =
      Try(ScenarioContext.get[String]("currentDuties")).fold(_ => None, Some(_))

    val maybePreviousDuty: Option[String] =
      Try(ScenarioContext.get[String]("currentDuty")).fold(_ => None, Some(_))

    ScenarioContext.remove("currentDuty")

    addLastToList(maybePreviousDuty, maybeCurrentDuties, "currentDuties")
  }

  def addDuty(dataTable: DataTable): Unit = {
    addPreviousDutyToDuties()
    val asMapTransposed =
      dataTable.transpose().asMap(classOf[String], classOf[String])

    val duty = getBodyAsString("duty")
      .replaceAll("<REPLACE_dutyId>", asMapTransposed.get("dutyId"))
      .replaceAll("<REPLACE_subTrans>", asMapTransposed.get("subTrans"))
      .replaceAll(
        "<REPLACE_originalDebtAmount>",
        asMapTransposed.get("originalDebtAmount")
      )
      .replaceAll(
        "<REPLACE_interestStartDate>",
        asMapTransposed.get("interestStartDate")
      )

    ScenarioContext.set("currentDuty", duty)

  }

  def addDebt(dataTable: DataTable): Unit = {
    val asMapTransposed =
      dataTable.transpose().asMap(classOf[String], classOf[String])

    addPreviousDebtToDebts()

    val debt = getBodyAsString("debt")
      .replaceAll("<REPLACE_debtId>", asMapTransposed.get("debtId"))
      .replaceAll("<REPLACE_mainTrans>", asMapTransposed.get("mainTrans"))

    ScenarioContext.set("currentDebt", debt)
  }

  def addDebtsToGenerateQuoteRequest(): Unit = {
    addPreviousDebtToDebts()

    val currentGenerateQuoteRequest =
      ScenarioContext.get[String]("generateQuoteRequest")
    val currentDebts                =
      Try(ScenarioContext.get[String]("currentDebts")).fold(_ => "", identity)
    val generateQuoteRequest        =
      currentGenerateQuoteRequest.replace("<REPLACE_debts>", currentDebts)
    ScenarioContext.set("generateQuoteRequest", generateQuoteRequest)
  }

  private def addPreviousDebtToDebts(): Unit = {
    addPreviousDutyToDuties()

    val dutiesOfPreviousDebt: String =
      Try(ScenarioContext.get[String]("currentDuties")).fold(_ => "", identity)

    val maybePreviousDebt: Option[String] =
      Try(ScenarioContext.get[String]("currentDebt")).fold(
        _ => None,
        debt => Some(debt.replace("<REPLACE_duties>", dutiesOfPreviousDebt))
      )
    val maybeCurrentDebts: Option[String] =
      Try(ScenarioContext.get[String]("currentDebts")).fold(_ => None, Some(_))

    ScenarioContext.remove("currentDuties")
    ScenarioContext.remove("currentDebt")

    addLastToList(maybePreviousDebt, maybeCurrentDebts, "currentDebts")
  }

  private def addLastToList(maybePrevious: Option[String], maybeCurrentBucket: Option[String], key: String) =
    (maybePrevious, maybeCurrentBucket) match {
      case (None, None)        => ()
      case (Some(d), Some(ds)) => ScenarioContext.set(key, s"$ds,$d")
      case (None, Some(ds))    => ScenarioContext.set(key, ds)
      case (Some(d), None)     => ScenarioContext.set(key, d)
    }

  def createGenerateQuoteRequestBody(dataTable: DataTable): Unit = {
    val asMapTransposed =
      dataTable.transpose().asMap(classOf[String], classOf[String])

    val generateQuoteRequest = getBodyAsString("generateQuoteRequest")
      .replaceAll("<REPLACE_customerReference>", asMapTransposed.get("customerReference"))
      .replaceAll("<REPLACE_channelIdentifier>", asMapTransposed.get("channelIdentifier"))
    ScenarioContext.set("generateQuoteRequest", generateQuoteRequest)
  }

  def createPlanRequestBody(dataTable: DataTable): Unit = {
    val asMapTransposed      =
      dataTable.transpose().asMap(classOf[String], classOf[String])
    val generateQuoteRequest = getBodyAsString("createPlanRequest")
      .replaceAll("<REPLACE_customerReference>", asMapTransposed.get("customerReference"))
      .replaceAll("<REPLACE_quoteReference>", asMapTransposed.get("quoteReference"))
      .replaceAll("<REPLACE_channelIdentifier>", asMapTransposed.get("channelIdentifier"))

    ScenarioContext.set("generateQuoteRequest", generateQuoteRequest)
    print(s"json create plan ************************ $generateQuoteRequest")

  }

  def createRequestParameters(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.transpose().asMap(classOf[String], classOf[String])

    ScenarioContext.set("customerReference", asMapTransposed.get("customerReference"))
    ScenarioContext.set("planId", asMapTransposed.get("planId"))
  }

  def createCreatePlanRequestBody(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.transpose().asMap(classOf[String], classOf[String])

    val updatePlanRequest = getBodyAsString("createPlanRequest")
      .replaceAll("<REPLACE_customerReference>", asMapTransposed.get("customerReference"))
      .replaceAll("<REPLACE_planId>", asMapTransposed.get("planId"))
      .replaceAll("<REPLACE_updateType>", asMapTransposed.get("updateType"))
      .replaceAll("<REPLACE_planStatus>", asMapTransposed.get("planStatus"))
      .replaceAll("<REPLACE_completeReason>", asMapTransposed.get("completeReason"))
      .replaceAll("<REPLACE_cancellationReason>", asMapTransposed.get("cancellationReason"))
      .replaceAll("<REPLACE_thirdPartyBank>", asMapTransposed.get("thirdPartyBank"))
      .replaceAll("<REPLACE_numberOfInstalments>", asMapTransposed.get("numberOfInstalments"))
      .replaceAll("<REPLACE_totalDebtAmount>", asMapTransposed.get("totalDebtAmount"))
      .replaceAll("<REPLACE_totalInterest>", asMapTransposed.get("totalInterest"))

    ScenarioContext.set("createPlanRequest", updatePlanRequest)
  }

  def createUpdatePlanRequestBody(dataTable: DataTable): Unit = {
    val asMapTransposed =
      dataTable.transpose().asMap(classOf[String], classOf[String])

    val updatePlanRequest = getBodyAsString("updatePlanRequest")
      .replaceAll("<REPLACE_customerReference>", asMapTransposed.get("customerReference"))
      .replaceAll("<REPLACE_planId>", asMapTransposed.get("planId"))
      .replaceAll("<REPLACE_updateType>", asMapTransposed.get("updateType"))
      .replaceAll("<REPLACE_planStatus>", asMapTransposed.get("planStatus"))
      .replaceAll("<REPLACE_completeReason>", asMapTransposed.get("completeReason"))
      .replaceAll("<REPLACE_cancellationReason>", asMapTransposed.get("cancellationReason"))
      .replaceAll("<REPLACE_thirdPartyBank>", asMapTransposed.get("thirdPartyBank"))
      .replaceAll("<REPLACE_paymentMethod>", asMapTransposed.get("paymentMethod"))
      .replaceAll("<REPLACE_paymentReference>", asMapTransposed.get("paymentReference"))

    ScenarioContext.set("updatePlanRequest", updatePlanRequest)
  }

  def getPlan(customerReference: String, planId: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(
      enrolments = Seq("read:time-to-pay-proxy"),
      userType = getRandomAffinityGroup,
      utr = "123456789012"
    )
    val baseUri     =
      s"$timeToPayProxyApiUrl/quote/$customerReference/$planId"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    WsClient.get(baseUri, headers = headers)
  }

  def putPlan(json: String, customerReference: String, planId: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(
      enrolments = Seq("read:time-to-pay-proxy"),
      userType = getRandomAffinityGroup,
      utr = "123456789012"
    )
    val baseUri     =
      s"$timeToPayProxyApiUrl/quote/$customerReference/$planId"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )

    WsClient.put(baseUri, headers = headers, Json.parse(json))
  }

  def postQuote(json: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(
      enrolments = Seq("read:time-to-pay-proxy"),
      userType = getRandomAffinityGroup,
      utr = "123456789012"
    )
    val baseUri     = s"$timeToPayProxyApiUrl/quote"
    val headers     = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )
    print("new Bearer Token ************************" + bearerToken)
    print("url ************************" + baseUri)
    WsClient.post(baseUri, headers = headers, Json.parse(json))
  }

  def createPlan(json: String): StandaloneWSResponse = {
    val bearerToken = createBearerToken(
      enrolments = Seq("read:time-to-pay-proxy"),
      userType = getRandomAffinityGroup,
      utr = "123456789012"
    )

    val baseUri = s"$timeToPayProxyApiUrl/quote/arrangement"
    val headers = Map(
      "Authorization" -> s"Bearer $bearerToken",
      "Content-Type"  -> "application/json",
      "Accept"        -> "application/vnd.hmrc.1.0+json"
    )

    WsClient.post(baseUri, headers = headers, Json.parse(json))
  }

}
