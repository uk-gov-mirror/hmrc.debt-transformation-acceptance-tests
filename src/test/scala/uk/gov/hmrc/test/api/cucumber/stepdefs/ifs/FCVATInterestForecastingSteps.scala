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
import uk.gov.hmrc.test.api.requests.FieldCollectionsVATRequests._
import uk.gov.hmrc.test.api.utils.ScenarioContext

class FCVATInterestForecastingSteps extends ScalaDsl with EN with Eventually with Matchers {


    Given("a fc vat debt item") { (dataTable: DataTable) =>
      createInterestForecastingRequestBodyFCVAT(dataTable)
    }

    Given("the fc vat debt item has payment history") { (dataTable: DataTable) =>
      addFCVATPaymentHistory(dataTable)
    }

    Given("the fc vat debt item has no payment history") { () =>
      fcVatCustomerWithNoPaymentHistory()
    }

    When("the debt item(s) is sent to the fc vat ifs service") { () =>
      val request  = ScenarioContext.get("fcVatDebtItem").toString
      println(s"IFS REQUEST --> $request")
      val response = getDebtCalculation(request)
      println(s"IFS RESPONSE --> ${response.body}")
      ScenarioContext.set("response", response)
    }

    Then("the fc vat ifs service wilL return a total debts summary of") { (dataTable: DataTable) =>
      val asMapTransposed = dataTable.transpose().asMap(classOf[String], classOf[String])
      val response: StandaloneWSResponse = ScenarioContext.get("response")

      val responseBody = Json.parse(response.body).as[FCVATDebtCalculationsSummary]


      if (asMapTransposed.containsKey("combinedDailyAccrual")) {
        responseBody.combinedDailyAccrual.toString shouldBe asMapTransposed.get("combinedDailyAccrual").toString
      }
      if (asMapTransposed.containsKey("unpaidAmountTotal")) {
        responseBody.unpaidAmountTotal.toString shouldBe asMapTransposed.get("unpaidAmountTotal").toString
      }
    }

    Then("the ([0-9]\\d*)(?:st|nd|rd|th) fc vat debt summary will contain") { (index: Int, dataTable: DataTable) =>
      val asMapTransposed                = dataTable.transpose().asMap(classOf[String], classOf[String])
      val response: StandaloneWSResponse = ScenarioContext.get("response")
      response.status should be(200)

      val responseBody: FCVATDebtCalculation =
        Json.parse(response.body).as[FCVATDebtCalculationsSummary].debtCalculations(index - 1)

      if (asMapTransposed.containsKey("interestRate")) {
        responseBody.interestRate.toString shouldBe asMapTransposed.get("interestRate").toString
      }
    }

//  Then("the ([0-9])(?:st|nd|rd|th) fc debt summary will have calculation windows") {
//    (summaryIndex: Int, dataTable: DataTable) =>
//      val asMapTransposed                = dataTable.asMaps(classOf[String], classOf[String])
//      val response: StandaloneWSResponse = ScenarioContext.get("response")
//
//      asMapTransposed.zipWithIndex.foreach { case (window, index) =>
//        val responseBody =
//          Json
//            .parse(response.body)
//            .as[FCDebtCalculationsSummary]
//            .debtCalculations(summaryIndex - 1)
//            .calculationWindows(index)
//
//        if (window.containsKey("periodFrom")) {
//          responseBody.periodFrom.toString shouldBe window.get("periodFrom").toString
//        }
//        if (window.containsKey("periodTo")) {
//          responseBody.periodTo.toString shouldBe window.get("periodTo").toString
//        }
//        if (window.containsKey("numberOfDays")) {
//          responseBody.numberOfDays.toString shouldBe window.get("numberOfDays").toString
//        }
//        if (window.containsKey("interestRate")) {
//          responseBody.interestRate.toString shouldBe window.get("interestRate").toString
//        }
//        if (window.containsKey("interestDueDailyAccrual")) {
//          responseBody.interestDueDailyAccrual.toString shouldBe window.get("interestDueDailyAccrual").toString
//        }
//        if (window.containsKey("interestDueWindow")) {
//          responseBody.interestDueWindow.toString shouldBe window.get("interestDueWindow").toString
//        }
//        if (window.containsKey("unpaidAmountWindow")) {
//          responseBody.unpaidAmountWindow.toString shouldBe window.get("unpaidAmountWindow").toString
//        }
//        if (window.containsKey("amountOnIntDueWindow")) {
//          responseBody.amountOnIntDueWindow.toString() shouldBe window.get("amountOnIntDueWindow").toString
//        }
//        if (window.containsKey("reason") && (window.get("reason") != "")) {
//          responseBody.suppressionApplied.head.reason shouldBe window.get("reason").toString
//        }
//        if (window.containsKey("code") && (window.get("code") != "")) {
//          responseBody.suppressionApplied.head.code shouldBe window.get("code").toString
//        }
//      }
//  }
    And("the fc vat customer has breathing spaces applied") { (dataTable: DataTable) =>
      addFCVATBreathingSpace(dataTable)
    }

    Given("no breathing spaces have been applied to the fc vat customer") { () =>
      noFCVatBreathingSpace()
    }

    Given("the fc vat customer has post codes") { (dataTable: DataTable) =>
      addFCVATCustomerPostCodes(dataTable)
    }

    Given("the fc vat customer has no post codes") { () =>
      noFCVatCustomerPostCodes()
    }

//  Then("the ([0-9])(?:st|nd|rd|th) fc debt summary will not have any calculation windows") { (summaryIndex: Int) =>
//    getFCCountOfCalculationWindows(summaryIndex) shouldBe 0
//  }
//
  Then("""the fc vat ifs service will respond with (.*)""") { (expectedMessage: String) =>
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.body   should include(expectedMessage)
    response.status should be(400)
  }
//
//    def getFCCountOfCalculationWindows(summaryIndex: Int): Int = {
//      val response: StandaloneWSResponse = ScenarioContext.get("response")
//      Json.parse(response.body).as[FCDebtCalculationsSummary].debtCalculations(summaryIndex - 1).calculationWindows.size
//    }
  }
