package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */
import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

final case class PaymentPlanSummaryResponse(
  dateOfCalculation: LocalDate,
  numberOfInstalments: Long,
  planInterest: Int,
  interestAccrued: Int,
  totalInterest: Int,
  duration: Long,
  instalments: Seq[PaymentPlanInstalmentResponse]
)

object PaymentPlanSummaryResponse {
  implicit val paymentPlanResponseFormat: OFormat[PaymentPlanSummaryResponse] = Json.format[PaymentPlanSummaryResponse]

}
