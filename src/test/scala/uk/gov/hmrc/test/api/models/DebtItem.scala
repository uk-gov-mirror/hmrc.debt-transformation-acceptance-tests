package uk.gov.hmrc.test.api.models

import java.time.LocalDate
import play.api.libs.json.{Json, OFormat}

case class DebtItem(
  uniqueItemReference: String,
  amount: BigDecimal,
  chargeType: ChargeType,
  regime: RegimeType,
  dateAmount: LocalDate,
  dateCalculationTo: LocalDate,
  paymentHistory: List[Payment],
  numberOfDays: Option[Long] = None,
  interestRate: Option[Double] = None
)

object DebtItem {
  implicit val formatDebtItem: OFormat[DebtItem] = Json.format[DebtItem]
}
