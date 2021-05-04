/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.statementofliability.models

import play.api.libs.json.Json

case class SolDuty(
        debtItemChargeID: String,
        subTrans: SubTransType,
        description: String,
        unpaidAmountDebt: Int,
        combinedDailyAccrual: Int
        ) { }

object SolDuty {
  implicit val format = Json.format[SolDuty]
}
