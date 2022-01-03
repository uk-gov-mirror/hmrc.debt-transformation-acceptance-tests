/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import java.time.LocalDate

import play.api.libs.json.{Json, OFormat}

case class FCCalculationWindow(
  periodFrom: LocalDate,
  periodTo: LocalDate,
  numberOfDays: Int,
  interestRate: Double,
  interestDueDailyAccrual: Int,
  interestDueWindow: Int,
  amountOnIntDueWindow: Int,
  unpaidAmountWindow: Int,
  suppressionApplied: Option[SuppressionApplied]
)

object FCCalculationWindow {
  implicit val formatDebtItemCalculationWindow: OFormat[FCCalculationWindow] =
    Json.format[FCCalculationWindow]
}
