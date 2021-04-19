/*
 * Copyright 2020 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package uk.gov.hmrc.test.api.cucumber.stepdefs.ifs

import io.cucumber.datatable.DataTable
import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import play.twirl.api.TwirlHelperImports.twirlJavaCollectionToScala
import uk.gov.hmrc.test.api.cucumber.stepdefs.BaseStepDef
import uk.gov.hmrc.test.api.models.{DebtCalculation, DebtItemCalculation}
import uk.gov.hmrc.test.api.requests.InterestForecastingRequests
import uk.gov.hmrc.test.api.requests.InterestForecastingRequests.getBodyAsString
import uk.gov.hmrc.test.api.utils.ScenarioContext

class InterestForecastingSteps extends BaseStepDef {

  Given("a debt item") { (dataTable: DataTable) =>
    val asMapTransposed   = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem         = false
    var debtItems: String = null

    try ScenarioContext.get("debtItems")
    catch { case e: Exception => firstItem = true }

    val debtItem = getBodyAsString("debtItem")
      .replaceAll("<REPLACE_uniqueItemReference>", "123")
      .replaceAll("<REPLACE_originalAmount>", asMapTransposed.get("originalAmount"))
      .replaceAll("<REPLACE_subTrans>", asMapTransposed.get("subTrans"))
      .replaceAll("<REPLACE_mainTrans>", asMapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_dateCreated>", asMapTransposed.get("dateCreated"))
      .replaceAll("<REPLACE_dateCalculationTo>", asMapTransposed.get("dateCalculationTo"))

    if (firstItem == true) { debtItems = debtItem }
    else { debtItems = ScenarioContext.get("debtItems").toString.concat(",").concat(debtItem) }

    ScenarioContext.set(
      "debtItems",
      debtItems
    )
  }

  Given("(.*) debt items") { (numberItems: Int) =>
    var debtItems: String = null
    var n                 = 0

    while (n < numberItems) {
      val debtItem = getBodyAsString("debtItem")
        .replaceAll("<REPLACE_uniqueItemReference>", "123")
        .replaceAll("<REPLACE_originalAmount>", "500000")
        .replaceAll("<REPLACE_subTrans>", "1000")
        .replaceAll("<REPLACE_mainTrans>", "1525")
        .replaceAll("<REPLACE_dateCreated>", "2021-12-16")
        .replaceAll("<REPLACE_dateCalculationTo>", "2022-04-14")

      if (n == 0) {
        debtItems = debtItem
      } else {
        debtItems = debtItems.concat(",").concat(debtItem)
      }

      ScenarioContext.set("debtItems", debtItems.toString.replaceAll("<REPLACE_payments>", ""))
      n = n + 1
    }
  }

  Given("(.*) debt items where interest rate changes from 2\\.75 to 2\\.6") { (numberItems: Int) =>
    var debtItems: String = null
    var n                 = 0

    while (n < numberItems) {
      val debtItem = getBodyAsString("debtItem")
        .replaceAll("<REPLACE_uniqueItemReference>", "123")
        .replaceAll("<REPLACE_originalAmount>", "500000")
        .replaceAll("<REPLACE_subTrans>", "1000")
        .replaceAll("<REPLACE_mainTrans>", "1525")
        .replaceAll("<REPLACE_dateCreated>", "2020-01-01")
        .replaceAll("<REPLACE_dateCalculationTo>", "2020-04-30")

      if (n == 0) {
        debtItems = debtItem
      } else {
        debtItems = debtItems.concat(",").concat(debtItem)
      }

      ScenarioContext.set("debtItems", debtItems.toString.replaceAll("<REPLACE_payments>", ""))
      n = n + 1
    }
  }

  Given("the debt item has payment history") { (dataTable: DataTable) =>
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    var payments        = ""

    asMapTransposed.zipWithIndex.foreach { case (payment, index) =>
      payments = payments.concat(
        getBodyAsString("payment")
          .replaceAll("<REPLACE_amountPaid>", payment.get("amountPaid"))
          .replaceAll("<REPLACE_dateOfPayment>", payment.get("dateOfPayment"))
      )

      if (index + 1 < asMapTransposed.size) payments = payments.concat(",")
    }

    val jsonWithPayments = ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_payments>", payments)
    ScenarioContext.set("debtItems", jsonWithPayments)
  }

  Given("the debt item has no payment history") { () =>
    ScenarioContext.set(
      "debtItems",
      ScenarioContext.get("debtItems").toString.replaceAll("<REPLACE_payments>", "")
    )
  }

  When("the debt item(s) is sent to the ifs service") { () =>
    val request = getBodyAsString("debtCalcRequest")
      .replaceAllLiterally("<REPLACE_debtItems>", ScenarioContext.get("debtItems"))

    val response =
      InterestForecastingRequests.getDebtCalculation(request)
    ScenarioContext.set("response", response)

  }

  Then("the ifs service wilL return a total debts summary of") { (dataTable: DataTable) =>
    val asMapTransposed                = dataTable.transpose().asMap(classOf[String], classOf[String])
    val response: StandaloneWSResponse = ScenarioContext.get("response")

    val responseBody = Json.parse(response.body).as[DebtCalculation]

    responseBody.combinedDailyAccrual.toString shouldBe asMapTransposed.get("combinedDailyAccrual").toString
    responseBody.interestDueCallTotal.toString shouldBe asMapTransposed.get("interestDueCallTotal").toString
    responseBody.unpaidAmountTotal.toString    shouldBe asMapTransposed.get("unpaidAmountTotal").toString
    responseBody.amountOnIntDueTotal.toString  shouldBe asMapTransposed
      .get("amountOnIntDueTotal")
      .toString
    responseBody.totalAmountIntTotal.toString  shouldBe asMapTransposed.get("totalAmountIntTotal").toString
  }

  Then("the ([0-9]\\d*)(?:st|nd|rd|th) debt summary will contain") { (index: Int, dataTable: DataTable) =>
    val asMapTransposed                = dataTable.transpose().asMap(classOf[String], classOf[String])
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.status should be(200)

    val responseBody: DebtItemCalculation = Json.parse(response.body).as[DebtCalculation].debtCalculations(index - 1)
    responseBody.interestDueDailyAccrual.toString shouldBe asMapTransposed.get("interestDueDailyAccrual").toString
    responseBody.interestDueDebtTotal.toString    shouldBe asMapTransposed.get("interestDueDebtTotal").toString
    responseBody.amountOnIntDueDebt.toString      shouldBe asMapTransposed
      .get("amountOnIntDueDebt")
      .toString
    responseBody.totalAmountIntDebt.toString      shouldBe asMapTransposed.get("totalAmountIntDebt").toString
    responseBody.unpaidAmountDebt.toString        shouldBe asMapTransposed.get("unpaidAmountDebt").toString

  }

  Then("""the ifs service will respond with (.*)""") { (expectedMessage: String) =>
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.body   should include(expectedMessage)
    response.status should be(400)
  }

  Then("the ([0-9])(?:st|nd|rd|th) debt summary will have calculation windows") {
    (summaryIndex: Int, dataTable: DataTable) =>
      val asMapTransposed                = dataTable.asMaps(classOf[String], classOf[String])
      val response: StandaloneWSResponse = ScenarioContext.get("response")

      asMapTransposed.zipWithIndex.foreach { case (window, index) =>
        val responseBody =
          Json.parse(response.body).as[DebtCalculation].debtCalculations(summaryIndex - 1).calculationWindows(index)

        responseBody.periodFrom.toString              shouldBe window.get("periodFrom").toString
        responseBody.periodTo.toString                shouldBe window.get("periodTo").toString
        responseBody.numberOfDays.toString            shouldBe window.get("numberOfDays").toString
        responseBody.interestRate.toString            shouldBe window.get("interestRate").toString
        responseBody.interestDueDailyAccrual.toString shouldBe window.get("interestDueDailyAccrual").toString
        responseBody.interestDueWindow.toString       shouldBe window.get("interestDueWindow").toString
        responseBody.unpaidAmountWindow.toString      shouldBe window.get("unpaidAmountWindow").toString
        responseBody.amountOnIntDueWindow
          .toString()                                 shouldBe window.get("unpaidAmountWindow").toString
      }
  }
}
