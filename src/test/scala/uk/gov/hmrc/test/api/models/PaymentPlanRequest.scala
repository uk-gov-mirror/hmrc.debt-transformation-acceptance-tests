package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

final case class PaymentPlanRequest(
  debtId: String,
  debtAmount: BigDecimal,
  instalmentPaymentAmount: BigDecimal,
  paymentFrequency: Frequency,
  instalmentPaymentDate: LocalDate,
  quoteDate: LocalDate,
  mainTrans: MainTransType,
  subTrans: SubTransType,
  interestAccrued: Int,
  initialPaymentDate: Option[LocalDate] = None,
  initialPaymentAmount: Option[BigDecimal] = None
)

object PaymentPlanRequest {
  implicit val PaymentPlanRequestFormat: OFormat[PaymentPlanRequest] = Json.format[PaymentPlanRequest]
}
