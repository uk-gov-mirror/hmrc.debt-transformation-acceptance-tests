/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}


/*
interestDueDebtTotal (Total Interest accrued) = 13,690 (12,786 + 904 + 0)
unpaidAmountDebt (Total Amount to pay) = 500,000
totalAmountIntDebt (Total Amount with interest) =  513,690
interestDueDailyAccrual (Daily interest accrual) = 35 (the latest accrual in the calculation window)
amountOnIntDueDebt (Total amount on which interest is due) = 500,000 
 */
case class DebtItemCalculation(
                                uniqueItemReference: String,
                                interestDueDailyAccrual: BigDecimal,
                                interestDueDebtTotal: BigDecimal,
                                amountOnIntDueDebt: BigDecimal,
                                numberOfChargeableDays: Long,
                                totalAmountIntDebt: BigDecimal,
                                unpaidAmountDebt: BigDecimal,
                                calculationWindows: List[DebtItemCalculationWindow] = Nil
                              )
object DebtItemCalculation {
  implicit val formatDebtCalculation: OFormat[DebtItemCalculation] = Json.format[DebtItemCalculation]
}
