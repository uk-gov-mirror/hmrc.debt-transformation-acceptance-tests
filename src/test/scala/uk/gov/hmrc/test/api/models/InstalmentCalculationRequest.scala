package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

final case class InstalmentCalculationRequest(
  debtId: String,
  debtAmount: BigDecimal,
  instalmentPaymentAmount: BigDecimal,
  paymentFrequency: Frequency,
  instalmentPaymentDate: LocalDate,
  quoteDate: LocalDate,
  mainTrans: MainTransType,
  subTrans: SubTransType,
  interestCallDueTotal: Int,
  initialPaymentDate: Option[LocalDate] = None,
  initialPaymentAmount: Option[BigDecimal] = None
)

object InstalmentCalculationRequest {
  implicit val instalmentCalculationRequestFormat: OFormat[InstalmentCalculationRequest] =
    Json.format[InstalmentCalculationRequest]
}
