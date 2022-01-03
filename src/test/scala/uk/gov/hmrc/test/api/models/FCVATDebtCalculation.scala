/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class FCVATDebtCalculation(
  interestRate: Double
)

object FCVATDebtCalculation {
  implicit val formatDebtCalculation: OFormat[FCVATDebtCalculation] = Json.format[FCVATDebtCalculation]
}
