/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models.sol

import play.api.libs.json.Json

case class SolDuty(
  dutyID: String,
  subTrans: String,
  dutyTypeDescription: String,
  unpaidAmountDuty: Int,
  combinedDailyAccrual: Int
)

object SolDuty {
  implicit val format = Json.format[SolDuty]
}
