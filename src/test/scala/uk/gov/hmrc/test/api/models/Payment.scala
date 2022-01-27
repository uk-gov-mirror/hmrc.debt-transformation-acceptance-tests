/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.Json

final case class Payment(paymentDate: String, paymentAmount: Int)

object Payment {
  implicit val format = Json.format[Payment]
}

