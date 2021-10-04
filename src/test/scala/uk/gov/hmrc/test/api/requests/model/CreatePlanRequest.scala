package uk.gov.hmrc.test.api.requests.model

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

case class CreatePlanRequest(customerReference: String,
                             quoteReference: String,
                             channelIdentifier: String,
                             plan: Plan,
                             debtItemCharges: Seq[DebtItemCharge],
                             payments: Seq[Payment],
                             customerPostCodes: Seq[PostCode],
                             instalments: Seq[Instalment])

case class Plan(quoteId: String,
                quoteType: String,
                quoteDate: String,
                instalmentStartDate: LocalDate,
                instalmentAmount: BigDecimal,
                paymentPlanType: String,
                thirdPartyBank: Boolean,
                numberOfInstalments: Int,
                frequency: String,
                duration: Int,
                initialPaymentDate: LocalDate,
                initialPaymentAmount: BigDecimal,
                totalDebtincInt: BigDecimal,
                totalInterest: BigDecimal,
                interestAccrued: BigDecimal,
                planInterest: BigDecimal)

case class DebtItemCharge(debtItemChargeId: String,
                          mainTrans: String,
                          subTrans: String,
                          originalDebtAmount: BigDecimal,
                          interestStartDate: LocalDate,
                          paymentHistory: Option[Seq[ChargePayment]])
case class ChargePayment(paymentDate: LocalDate, paymentAmount: BigDecimal)
case class Payment(paymentMethod: String, paymentReference: String)
case class PostCode(addressPostcode: String, postcodeDate: LocalDate)
case class Instalment(debtItemChargeId: String,
                      dueDate: LocalDate,
                      amountDue: BigDecimal,
                      expectedPayment: BigDecimal,
                      interestRate: Double,
                      instalmentNumber: Int,
                      instalmentInterestAccrued: BigDecimal,
                      instalmentBalance: BigDecimal)


object PostCode {
  implicit val formats: OFormat[PostCode] = Json.format[PostCode]
}
object ChargePayment {
  implicit val formats: OFormat[ChargePayment] = Json.format[ChargePayment]
}
object DebtItemCharge {
  implicit val formats: OFormat[DebtItemCharge] = Json.format[DebtItemCharge]
}
object Payment {
  implicit val formats: OFormat[Payment] = Json.format[Payment]
}
object Instalment {
  implicit val formats = Json.format[Instalment]
}
object Plan {
  implicit val formats: OFormat[Plan] = Json.format[Plan]
}
object CreatePlanRequest {
  implicit val formats: OFormat[CreatePlanRequest] = Json.format[CreatePlanRequest]
}







