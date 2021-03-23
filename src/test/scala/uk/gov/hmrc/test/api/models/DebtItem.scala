package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class DebtItem(
  dailyInterestAccrued: BigDecimal,
  interestRateApplied: Int,
  numberOfChargeableDays: Int,
  totalAmountToPay: BigDecimal,
  totalInterestAccrued: BigDecimal,
  totalAmountWithInterest: BigDecimal
)

object DebtItem {
    implicit val format: OFormat[DebtItem] = Json.format
}
