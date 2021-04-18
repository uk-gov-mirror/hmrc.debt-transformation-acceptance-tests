/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate


case class DebtItemCalculationWindow(periodFrom: LocalDate,
                                     periodTo: LocalDate,
                                     numberOfDays: Long,
                                     interestRate: Double,
                                     interestDueWindow: BigDecimal,
                                     interestDueDailyAccrual: BigDecimal,
                                     amountOnIntDueWindow: BigDecimal,
                                     unpaidAmountWindow: BigDecimal)

object DebtItemCalculationWindow {
  implicit val formatDebtItemCalculationWindow: OFormat[DebtItemCalculationWindow] = Json.format[DebtItemCalculationWindow]
}
