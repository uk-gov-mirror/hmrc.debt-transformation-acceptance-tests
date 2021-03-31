/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class Calculation(debtItems: Seq[DebtItem])

object Calculation {
  implicit val formatCalculation: OFormat[Calculation] = Json.format[Calculation]
}