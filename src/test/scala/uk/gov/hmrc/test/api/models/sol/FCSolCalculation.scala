/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models.sol

import play.api.libs.json.{Json, OFormat}

case class FCSolCalculation(
  debtId: String,
  interestDueDebtTotal: BigInt,
  totalAmountIntDebt: BigDecimal
)

object FCSolCalculation {
  implicit val formatOutputVariables: OFormat[FCSolCalculation] = Json.format[FCSolCalculation]
}
