/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class DebtCalculation(calculationWindow: List[CalculationWindow])

object DebtCalculation {
  implicit val formatDebtCalculation: OFormat[DebtCalculation] = Json.format[DebtCalculation]
}
