/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.statementofliability.actions.responses

import play.api.libs.json.{Json, OFormat}
import uk.gov.hmrc.statementofliability.models.{SolCalculation, SolCalculationSummary}

case class SolCalculationSummaryResponse(totalAmountIntDebt: Int, combinedDailyAccrual: Int, debts: List[SolCalculation]) {
}


object  SolCalculationSummaryResponse {
  implicit val solResponseFormat: OFormat[SolCalculationSummaryResponse] = Json.format[SolCalculationSummaryResponse]

  def apply(solCalculationSummary: SolCalculationSummary): SolCalculationSummaryResponse = SolCalculationSummaryResponse(
    totalAmountIntDebt =  solCalculationSummary.totalAmountIntDebt,
    combinedDailyAccrual =  solCalculationSummary.combinedDailyAccrual,
    debts = solCalculationSummary.debts
  )
}
