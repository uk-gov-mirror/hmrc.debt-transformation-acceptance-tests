/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models.sol

import play.api.libs.json.{Json, OFormat}

case class FCSolCalculationSummaryResponse(
  amountIntTotal: BigDecimal,
  combinedDailyAccrual: Int,
  debts: List[FCSolCalculation]
)

object FCSolCalculationSummaryResponse {
  implicit val solResponseFormat: OFormat[FCSolCalculationSummaryResponse] =
    Json.format[FCSolCalculationSummaryResponse]

}
