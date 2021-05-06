/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class SolCalculationSummaryResponse(
  totalAmountIntDebt: Int,
  combinedDailyAccrual: Int,
  debts: List[SolCalculation]
) {}

object SolCalculationSummaryResponse {
  implicit val solResponseFormat: OFormat[SolCalculationSummaryResponse] = Json.format[SolCalculationSummaryResponse]

  def apply(solCalculationSummary: SolCalculationSummary): SolCalculationSummaryResponse =
    SolCalculationSummaryResponse(
      totalAmountIntDebt = solCalculationSummary.totalAmountIntDebt,
      combinedDailyAccrual = solCalculationSummary.combinedDailyAccrual,
      debts = solCalculationSummary.debts
    )
}
