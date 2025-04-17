/*
 * Copyright 2023 HM Revenue & Customs
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

package uk.gov.hmrc.test.api.requests

import cucumber.api.scala.{EN, ScalaDsl}
import io.cucumber.datatable.DataTable
import org.scalatest.Matchers
import org.scalatest.concurrent.Eventually
import uk.gov.hmrc.test.api.models.sol.CustomerPostCode
import uk.gov.hmrc.test.api.models.{DebtItem, Payment}
import uk.gov.hmrc.test.api.utils.{BaseRequests, ScenarioContext}

import java.time.LocalDate
import scala.collection.mutable.ListBuffer
import scala.jdk.CollectionConverters._


object InterestForecastingDebtsRequests extends ScalaDsl with EN with Eventually with Matchers with BaseRequests {



  def createDebtItemRequest(dataTable: DataTable): Unit = {
    val asmapTransposed = dataTable.asMaps[String, String](classOf[String], classOf[String]).asScala.map(_.asScala)
    val debtItems = ListBuffer[DebtItem]()

    asmapTransposed.foreach { duty =>
      val originalDebtAmount = duty.get("originalDebtAmount").map(BigDecimal(_)).getOrElse(BigDecimal(0))
      val interestStartDate = duty.get("interestStartDate").map(LocalDate.parse).getOrElse(LocalDate.now())
      val interestRequestedTo = duty.get("interestRequestedTo").map(LocalDate.parse)
      val mainTrans = duty.get("mainTrans")
      val subTrans = duty.get("subTrans")
      val interestBearing = duty.get("interestBearing")
      val periodEnd = duty.get("periodEnd")

      val debtItem = DebtItem(
        originalDebtAmount = originalDebtAmount,
        interestStartDate = interestStartDate,
        interestRequestedTo = interestRequestedTo,
        mainTrans = mainTrans,
        subTrans = subTrans,
        interestBearing = interestBearing,
        periodEnd = periodEnd
      )

      debtItems += debtItem
    }

    ScenarioContext.set("debtItems", debtItems.toList)

    ScenarioContext.set("debtItems", debtItems)
    print("IFS debt-calculation request::::::::::::::::::" + debtItems)
  }


  def addPaymentHistory(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String]).asScala
    var paymentHistory = List[Payment]()

    asMapTransposed.zipWithIndex.foreach { case (paymnt, index) =>
      val payment = Payment(
        if (paymnt.toString.contains("paymentDate")) paymnt.get("paymentDate")
        else LocalDate.of(2021, 3, 1).toString,
        paymnt.get("paymentAmount").toString.toInt
      )
      if (index < asMapTransposed.size) paymentHistory ::= payment
    }
    ScenarioContext.setPaymentHistory("paymentHistory", paymentHistory)
  }

  def addEmptyPaymentHistory(): Unit =
    ScenarioContext.set("paymentHistory", "")

  def addPostcode(dataTable: DataTable): Unit = {
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String]).asScala
    var customerPostcodes = List[CustomerPostCode]()

    asMapTransposed.zipWithIndex.foreach { case (postCode, index) =>
      val customerPostCode = CustomerPostCode(
        postCode.get("postCode"),
        postCode.get("postcodeDate")
      )
      if (index < asMapTransposed.size) customerPostcodes ::= customerPostCode
    }
    ScenarioContext.set("customerPostcode", customerPostcodes)
  }
}
