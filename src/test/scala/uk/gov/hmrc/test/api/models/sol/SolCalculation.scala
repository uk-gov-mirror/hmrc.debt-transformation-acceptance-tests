/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models.sol

import play.api.libs.json.{Json, OFormat}

case class SolCalculation(
  debtId: String,
  mainTrans: String,
  debtTypeDescription: String,
  interestDueDebtTotal: BigInt,
  totalAmountIntDebt: BigInt,
  combinedDailyAccrual: BigInt,
  duties: Seq[SolDuty]
)

object SolCalculation {
  implicit val formatOutputVariables: OFormat[SolCalculation] = Json.format[SolCalculation]
}
