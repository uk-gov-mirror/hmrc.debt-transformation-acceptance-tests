/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import scala.math.BigDecimal.RoundingMode
import scala.math.BigDecimal.RoundingMode.RoundingMode

case class CalculatedDebt(dailyInterestAccrued: BigDecimal,
                          interestRateApplied: BigDecimal,
                          numberOfChargeableDays: Long,
                          totalAmountToPay: BigDecimal,
                          debtCalculations: Seq[DebtCalculation]) {

  import CalculatedDebt._

  val totalInterestAccrued = (dailyInterestAccrued * numberOfChargeableDays).defaultRound()
  val totalAmountWithInterest = (totalInterestAccrued + totalAmountToPay).defaultRound()
}

object CalculatedDebt {
  implicit val formatOutputVariables: OFormat[CalculatedDebt] = Json.format[CalculatedDebt]
  private[CalculatedDebt] val roundingMode = RoundingMode.FLOOR

  implicit class DoubleExtensionMethods(bigDecimal: BigDecimal) {
    def defaultRound(roundingMode: RoundingMode = roundingMode) = bigDecimal.setScale(2, roundingMode)
  }
}