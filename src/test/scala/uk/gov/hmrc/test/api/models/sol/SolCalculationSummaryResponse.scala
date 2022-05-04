/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models.sol

import play.api.libs.json.{Json, OFormat}

case class SolCalculationSummaryResponse(
  amountIntTotal: BigInt,
  combinedDailyAccrual: BigInt,
  debts: List[SolCalculation]
)

object SolCalculationSummaryResponse {
  implicit val solResponseFormat: OFormat[SolCalculationSummaryResponse] = Json.format[SolCalculationSummaryResponse]

}
