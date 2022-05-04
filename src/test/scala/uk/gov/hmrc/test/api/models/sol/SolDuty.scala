/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models.sol

import play.api.libs.json.Json

case class SolDuty(
  dutyId: String,
  subTrans: String,
  dutyTypeDescription: String,
  unpaidAmountDuty: BigInt,
  combinedDailyAccrual: BigInt,
  interestBearing: Boolean,
  interestOnlyIndicator: Boolean
)

object SolDuty {
  implicit val format = Json.format[SolDuty]
}
