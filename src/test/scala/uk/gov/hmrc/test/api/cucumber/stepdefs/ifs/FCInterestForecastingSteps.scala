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

import cucumber.api.scala.{EN, ScalaDsl}
import io.cucumber.datatable.DataTable
import org.scalatest.Matchers
import org.scalatest.concurrent.Eventually
import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.models._
import uk.gov.hmrc.test.api.requests.FieldCollectionsRequests._
import uk.gov.hmrc.test.api.utils.ScenarioContext

import scala.collection.convert.WrapAsScala.collectionAsScalaIterable

class FCInterestForecastingSteps extends ScalaDsl with EN with Eventually with Matchers {

  Given("a fc debt item") { (dataTable: DataTable) =>
    createInterestFocastingRequestBodyFC(dataTable)
  }

  Given("fc debt item with cotax charge interest")
  { (dataTable: DataTable) =>
    createFcCotaxChargeInterestRequest(dataTable)
  }

  Given("the debt item has fc payment history") { (dataTable: DataTable) =>
    addFCPaymentHistory(dataTable)
  }

  Given("the fc debt item has no payment history") { () =>
    fcCustomerWithNoPaymentHistory()
  }

  When("the debt item(s) is sent to the fc ifs service") { () =>
    val request  = ScenarioContext.get("fcDebtItem").toString
    println(s"IFS REQUEST --> $request")
    val response = getDebtCalculation(request)
    println(s"IFS RESPONSE --> ${response.body}")
    ScenarioContext.set("response", response)
  }

  Then("the fc ifs service wilL return a total debts summary of") { (dataTable: DataTable) =>
    val asMapTransposed                = dataTable.transpose().asMap(classOf[String], classOf[String])
    val response: StandaloneWSResponse = ScenarioContext.get("response")

    val responseBody = Json.parse(response.body).as[FCDebtCalculationsSummary]

    if (asMapTransposed.containsKey("combinedDailyAccrual")) {
      responseBody.combinedDailyAccrual.toString shouldBe asMapTransposed.get("combinedDailyAccrual").toString
    }
    if (asMapTransposed.containsKey("unpaidAmountTotal")) {
      responseBody.unpaidAmountTotal.toString shouldBe asMapTransposed.get("unpaidAmountTotal").toString
    }

    if (asMapTransposed.containsKey("interestDueCallTotal")) {
      responseBody.interestDueCallTotal.toString shouldBe asMapTransposed.get("interestDueCallTotal").toString
    }
    if (asMapTransposed.containsKey("totalAmountIntTotal")) {
      responseBody.totalAmountIntTotal.toString shouldBe asMapTransposed.get("totalAmountIntTotal").toString
    }
    if (asMapTransposed.containsKey("amountOnIntDueTotal")) {
      responseBody.amountOnIntDueTotal.toString shouldBe asMapTransposed.get("amountOnIntDueTotal").toString
    }
  }

  Then("the ([0-9]\\d*)(?:st|nd|rd|th) fc debt summary will contain") { (index: Int, dataTable: DataTable) =>
    val asMapTransposed                = dataTable.transpose().asMap(classOf[String], classOf[String])
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.status should be(200)

    val responseBody: FCDebtCalculation =
      Json.parse(response.body).as[FCDebtCalculationsSummary].debtCalculations(index - 1)

    if (asMapTransposed.containsKey("debtItemChargeId")) {
      responseBody.debtItemChargeId.toString shouldBe asMapTransposed.get("debtItemChargeId").toString
    }

    if (asMapTransposed.containsKey("interestDueDailyAccrual")) {
      responseBody.interestDueDailyAccrual.toString shouldBe asMapTransposed.get("interestDueDailyAccrual").toString
    }
    if (asMapTransposed.containsKey("interestDueDutyTotal")) {
      responseBody.interestDueDutyTotal.toString shouldBe asMapTransposed.get("interestDueDutyTotal").toString
    }
    if (asMapTransposed.containsKey("amountOnIntDueDuty")) {
      responseBody.amountOnIntDueDuty.toString shouldBe asMapTransposed.get("amountOnIntDueDuty").toString
    }
    if (asMapTransposed.containsKey("totalAmountIntDuty")) {
      responseBody.totalAmountIntDuty.toString shouldBe asMapTransposed.get("totalAmountIntDuty").toString
    }
    if (asMapTransposed.containsKey("unpaidAmountDuty")) {
      responseBody.unpaidAmountDuty.toString shouldBe asMapTransposed.get("unpaidAmountDuty").toString
    }
  }

  Then("the ([0-9])(?:st|nd|rd|th) fc debt summary will have calculation windows") {
    (summaryIndex: Int, dataTable: DataTable) =>
      val asMapTransposed                = dataTable.asMaps(classOf[String], classOf[String])
      val response: StandaloneWSResponse = ScenarioContext.get("response")

      asMapTransposed.zipWithIndex.foreach { case (window, index) =>
        val responseBody =
          Json
            .parse(response.body)
            .as[FCDebtCalculationsSummary]
            .debtCalculations(summaryIndex - 1)
            .calculationWindows(index)

        if (window.containsKey("periodFrom")) {
          responseBody.periodFrom.toString shouldBe window.get("periodFrom").toString
        }
        if (window.containsKey("periodTo")) {
          responseBody.periodTo.toString shouldBe window.get("periodTo").toString
        }
        if (window.containsKey("numberOfDays")) {
          responseBody.numberOfDays.toString shouldBe window.get("numberOfDays").toString
        }
        if (window.containsKey("interestRate")) {
          responseBody.interestRate.toString shouldBe window.get("interestRate").toString
        }
        if (window.containsKey("interestDueDailyAccrual")) {
          responseBody.interestDueDailyAccrual.toString shouldBe window.get("interestDueDailyAccrual").toString
        }
        if (window.containsKey("interestDueWindow")) {
          responseBody.interestDueWindow.toString shouldBe window.get("interestDueWindow").toString
        }
        if (window.containsKey("unpaidAmountWindow")) {
          responseBody.unpaidAmountWindow.toString shouldBe window.get("unpaidAmountWindow").toString
        }
        if (window.containsKey("amountOnIntDueWindow")) {
          responseBody.amountOnIntDueWindow.toString() shouldBe window.get("amountOnIntDueWindow").toString
        }
        if (window.containsKey("reason") && (window.get("reason") != "")) {
          responseBody.suppressionApplied.head.reason shouldBe window.get("reason").toString
        }
        if (window.containsKey("code") && (window.get("code") != "")) {
          responseBody.suppressionApplied.head.code shouldBe window.get("code").toString
        }
      }
  }
  And("the fc customer has breathing spaces applied") { (dataTable: DataTable) =>
    addFCBreathingSpace(dataTable)
  }

  Given("no breathing spaces have been applied to the debt item") { () =>
    noFCBreathingSpace()
  }

  Given("the fc customer has post codes") { (dataTable: DataTable) =>
    addFCCustomerPostCodes(dataTable)
  }

  Given("add charge interest cotax") { (dataTable: DataTable) =>
    addChargedInterestCotax(dataTable)
  }

  Given("the fc customer has no post codes") { () =>
    noFCCustomerPostCodes()
  }

  Then("the ([0-9])(?:st|nd|rd|th) fc debt summary will not have any calculation windows") { (summaryIndex: Int) =>
    getFCCountOfCalculationWindows(summaryIndex) shouldBe 0
  }

  Then("""the fc ifs service will respond with (.*)""") { (expectedMessage: String) =>
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.body   should include(expectedMessage)
    response.status should be(400)
  }

  Then("the ([0-9])(?:st|nd|rd|th) fc debt summary will have ([0-9]) calculation windows") {
    (summaryIndex: Int, numberOfWindows: Int) =>
      getFCCountOfCalculationWindows(summaryIndex) shouldBe numberOfWindows
  }

  def getFCCountOfCalculationWindows(summaryIndex: Int): Int = {
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    Json.parse(response.body).as[FCDebtCalculationsSummary].debtCalculations(summaryIndex - 1).calculationWindows.size
  }
}
