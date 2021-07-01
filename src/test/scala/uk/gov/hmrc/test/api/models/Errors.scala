/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class Errors(
  statusCode: Int,
  reason: String,
  message: String
)

object Errors {
  implicit val formatErrors: OFormat[Errors] = Json.format[Errors]
}
