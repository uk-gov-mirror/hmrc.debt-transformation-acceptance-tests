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

package uk.gov.hmrc.test.api.cucumber.stepdefs

import cucumber.api.scala.{EN, ScalaDsl}
import io.cucumber.datatable.DataTable
import org.scalatest.Matchers
import org.scalatest.concurrent.Eventually
import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.models.{SolCalculation, SolCalculationSummary, SolCalculationSummaryResponse}
import uk.gov.hmrc.test.api.utils.ScenarioContext

import scala.collection.convert.ImplicitConversions.`collection AsScalaIterable`

trait BaseStepDef extends ScalaDsl with EN with Eventually with Matchers {

  Then("service returns debt statement of liability data") { (dataTable: DataTable) =>
    val asMapTransposed                = dataTable.transpose().asMap(classOf[String], classOf[String])
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.status should be(200)

    val responseBody = Json.parse(response.body).as[SolCalculationSummaryResponse]
    
    responseBody.totalAmountIntDebt.toString shouldBe asMapTransposed.get("totalAmountIntDebt").toString
    responseBody.combinedDailyAccrual.toString shouldBe asMapTransposed.get("combinedDailyAccrual").toString

  }

  Then("the ([0-9]\\d*)(?:st|nd|rd|th) sol debt summary will contain") { (index: Int, dataTable: DataTable) =>
    val asMapTransposed                = dataTable.transpose().asMap(classOf[String], classOf[String])
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.status should be(200)

    val debt: SolCalculation = Json.parse(response.body).as[SolCalculationSummary].debts(index - 1)
    debt.uniqueItemReference      shouldBe asMapTransposed.get("uniqueItemReference").toString
    debt.mainTrans                shouldBe asMapTransposed.get("mainTrans").toString
    debt.description             shouldBe asMapTransposed.get("description").toString
    debt.periodEnd.toString                shouldBe asMapTransposed.get("periodEnd").toString
    debt.interestDueDebtTotal.toString     shouldBe asMapTransposed.get("interestDueDebtTotal").toString
  }

  Then("the ([0-9])(?:st|nd|rd|th) sol debt summary will contain duties") { (debtIndex: Int, dataTable: DataTable) =>
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    val response: StandaloneWSResponse = ScenarioContext.get("response")

    asMapTransposed.zipWithIndex.foreach { case (duty, index) => val responseBody = Json.parse(response.body).as[SolCalculationSummary]
                                                     .debts(debtIndex - 1).duties(index)

      responseBody.debtItemChargeID     shouldBe duty.get("debtItemChargeID").toString
      responseBody.subTrans             shouldBe duty.get("subTrans").toString
      responseBody.description          shouldBe duty.get("description").toString
      responseBody.unpaidAmountDebt.toString     shouldBe duty.get("unpaidAmountDebt").toString
      responseBody.combinedDailyAccrual.toString shouldBe duty.get("combinedDailyAccrual").toString
    }
  }
}
