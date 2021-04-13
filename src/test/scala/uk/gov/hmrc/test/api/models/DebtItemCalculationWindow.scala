/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate


/*
periodFrom (Date From) = 07/04/2020.  (The date the interest rate changes)
periodTo (Date To) = 31/03/2021 (the day the interest was requested)
numberOfDays (Num of days) = 359 days (inclusive)
interestRate (Int rate) = 2.6%
interestDueWindow (Total interest due) =  12,786  (35 * 359)
interestDueDailyAccrual (Daily Interest due) = 35 (500,000 x 0.026/365)
unpaidAmountWindow (Total debt amount unpaid) = 500,000
amountOnIntDueWindow (Total amount on which interest is due) = 500,000
 */
case class DebtItemCalculationWindow(periodFrom: LocalDate,
                                     periodTo: LocalDate,
                                     numberOfDays: Long,
                                     interestRate: Long,
                                     interestDueWindow: BigDecimal,
                                     interestDueDailyAccrual: BigDecimal,
                                     amountOnIntDueWindow: BigDecimal,
                                     unpaidAmountWindow: BigDecimal)

object DebtItemCalculationWindow {
  implicit val formatDebtItemCalculationWindow: OFormat[DebtItemCalculationWindow] = Json.format[DebtItemCalculationWindow]
}
