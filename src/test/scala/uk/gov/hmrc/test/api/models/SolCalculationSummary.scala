/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class SolCalculationSummary(debts: List[SolCalculation]) {
  val totalAmountIntDebt: Int   = debts.map(_.interestDueDebtTotal).sum
  val combinedDailyAccrual: Int = debts.map(_.combinedDailyAccrual).sum
}

object SolCalculationSummary {
  implicit val formatOutputVariables: OFormat[SolCalculationSummary] = Json.format[SolCalculationSummary]
}
