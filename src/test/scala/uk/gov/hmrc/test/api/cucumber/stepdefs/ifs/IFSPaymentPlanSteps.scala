package uk.gov.hmrc.test.api.cucumber.stepdefs.ifs

import cucumber.api.scala.{EN, ScalaDsl}
import io.cucumber.datatable.DataTable
import java.time.LocalDate
import org.scalatest.Matchers
import org.scalatest.concurrent.Eventually
import play.api.libs.json.Json
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.models.{PaymentPlanInstalmentResponse, PaymentPlanSummary, PaymentPlanSummaryResponse}
import uk.gov.hmrc.test.api.requests.IFSPaymentPlanRequests.{_}
import uk.gov.hmrc.test.api.utils.ScenarioContext

class IFSPaymentPlanSteps extends ScalaDsl with EN with Eventually with Matchers {

  Given("debt payment plan with details") { (dataTable: DataTable) =>
    createPaymentPlanRequestBody(dataTable)
  }

  Given("the payment plan has debt item charges") { (dataTable: DataTable) =>
    addDebtChargeItemsToPaymentPlan(dataTable)
  }

  Given("debt plan details with initial payment") { (dataTable: DataTable) =>
    debtPlanDetailsWithInitailPaymentRequest(dataTable)
  }

  Given("debt instalment payment plan request details") { (dataTable: DataTable) =>
    debtInstalmentPaymentPlanRequest(dataTable)
  }

  Given("debt payment plan frequency details") { (dataTable: DataTable) =>
    createPaymentPlanFrequency(dataTable)
  }
  Given("plan details with initialPaymentDate is after instalmentPaymentDate") { (dataTable: DataTable) =>
    initialPaymentDateAfterInstalmentDate(dataTable)
  }

  Given("plan details with no initial payment amount") { (dataTable: DataTable) =>
    noInitialPaymentAmount(dataTable)
  }

  Given("plan details with quote date in past") { (dataTable: DataTable) =>
    frequencyPlanWithQuoteDateInPast(dataTable)
  }
  Given("plan details with no instalment date") { (dataTable: DataTable) =>
    noInstalmentDate(dataTable)
  }
  Given("plan details with no quote date") { (dataTable: DataTable) =>
    noQuoteDate(dataTable)
  }

  Given("plan details with no initial payment date") { (dataTable: DataTable) =>
    noInitialPaymentDate(dataTable)
  }

  Given("no initial payment date for the plan") { () =>
    noInstalmentDate()
  }

  When("the payment plan detail(s) is sent to the ifs service") { () =>
    val request  = ScenarioContext.get("paymentPlan").toString
    println(s"IFS REQUST --> $request")
    val response = getPaymentPlan(request)
    println(s"RESP --> ${response.body}")
    ScenarioContext.set("response", response)
  }

  Then("ifs service returns weekly payment freqeuncy instalment calculation plan") { () =>
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.status shouldBe 200
    val quoteDate                 = LocalDate.now
    val instalmentPaymentDate     = quoteDate.plusDays(1)
    val debtId                    = "debtId"
    val responseBody              = Json.parse(response.body).as[PaymentPlanSummary].instalments
    val actualnumberOfInstalments = Json.parse(response.body).as[PaymentPlanSummary].numberOfInstalments

    val expectedPaymentPlanResponse = PaymentPlanSummaryResponse(
      quoteDate,
      11,
      39,
      1423,
      1423 + 39,
      11,
      Vector(
        PaymentPlanInstalmentResponse(debtId, 1, instalmentPaymentDate, 10000, 100000, 7, 10000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 2, instalmentPaymentDate.plusWeeks(1), 10000, 90000, 6, 10000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 3, instalmentPaymentDate.plusWeeks(2), 10000, 80000, 5, 30000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 4, instalmentPaymentDate.plusWeeks(3), 10000, 70000, 4, 40000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 5, instalmentPaymentDate.plusWeeks(4), 10000, 60000, 4, 50000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 6, instalmentPaymentDate.plusWeeks(5), 10000, 50000, 3, 60000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 7, instalmentPaymentDate.plusWeeks(6), 10000, 40000, 2, 70000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 8, instalmentPaymentDate.plusWeeks(7), 10000, 30000, 2, 80000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 9, instalmentPaymentDate.plusWeeks(8), 10000, 20000, 1, 90000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 10, instalmentPaymentDate.plusWeeks(9), 10000, 10000, 0, 100000, 2.6),
        PaymentPlanInstalmentResponse(debtId, 11, instalmentPaymentDate.plusWeeks(10), 1462, 0, 0, 100000 + 1462, 2.6)
      )
    )

    actualnumberOfInstalments             shouldBe expectedPaymentPlanResponse.numberOfInstalments
    responseBody.map(_.dueDate)           shouldBe expectedPaymentPlanResponse.instalments.map(
      _.dueDate
    )
    responseBody.map(_.instalmentBalance) shouldBe expectedPaymentPlanResponse.instalments.map(_.instalmentBalance)
  }

}
