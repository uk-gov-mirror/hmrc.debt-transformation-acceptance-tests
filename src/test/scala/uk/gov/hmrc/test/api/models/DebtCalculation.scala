/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

/*
interestDueCallTotal (Total Interest accrued) =  13,690
combinedDailyAccrual = 35
unpaidAmountTotal (Total Amount to pay) = 500,000
totalAmountIntTotal (Total Amount with interests) =  513,690
amountOnIntDueTotal (Total amount on which interests) are due = 500,000
 */
case class DebtCalculation(combinedDailyAccrual: BigDecimal,
                           interestDueCallTotal: BigDecimal,
                           totalAmountIntTotal: BigDecimal,
                           amountOnIntDueTotal: BigDecimal,
                           unpaidAmountTotal: BigDecimal,
                           debtCalculations: List[DebtItemCalculation])

object DebtCalculation {
  implicit val formatDebtCalculation: OFormat[DebtCalculation] = Json.format[DebtCalculation]
}
