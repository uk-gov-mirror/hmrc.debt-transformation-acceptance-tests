/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import java.time.LocalDate

import play.api.libs.json.{Json, OFormat}

case class FCDebtCalculationsSummary(
  dateOfCalculation: Option[LocalDate],
  combinedDailyAccrual: Int,
  unpaidAmountTotal: Int,
  interestDueCallTotal: Int,
  totalAmountIntTotal: Int,
  amountOnIntDueTotal: Int,
  debtCalculations: List[FCDebtCalculation]
)

object FCDebtCalculationsSummary {
  implicit val formatDebtCalculation: OFormat[FCDebtCalculationsSummary] = Json.format[FCDebtCalculationsSummary]
}
