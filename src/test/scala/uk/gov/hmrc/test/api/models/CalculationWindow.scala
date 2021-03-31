/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

case class CalculationWindow(dateFrom: LocalDate,
                             dateTo: LocalDate,
                             numberOfChargeableDays: Long,
                             interestRateApplied: BigDecimal,
                             dailyInterestAccrued: BigDecimal,
                             totalInterestAccrued: BigDecimal)

object CalculationWindow {
  implicit val formatDebtCalculation: OFormat[CalculationWindow] = Json.format[CalculationWindow]
}
