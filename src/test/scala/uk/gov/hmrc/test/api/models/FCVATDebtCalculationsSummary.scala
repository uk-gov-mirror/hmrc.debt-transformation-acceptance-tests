/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import java.time.LocalDate

import play.api.libs.json.{Json, OFormat}

case class FCVATDebtCalculationsSummary(
  dateOfCalculation: Option[LocalDate],
  combinedDailyAccrual: Int,
  unpaidAmountTotal: Int,
  debtCalculations: List[FCVATDebtCalculation]
)

object FCVATDebtCalculationsSummary {
  implicit val formatDebtCalculation: OFormat[FCVATDebtCalculationsSummary] = Json.format[FCVATDebtCalculationsSummary]
}
