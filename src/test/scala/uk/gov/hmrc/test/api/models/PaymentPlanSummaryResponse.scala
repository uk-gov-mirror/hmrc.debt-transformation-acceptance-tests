package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */
import play.api.libs.json.{Json, OFormat}

final case class PaymentPlanSummaryResponse(
  totalNumberOfInstalments: Long,
  totalPlanInt: Int,
  interestAccrued: Int,
  totalInterest: Int,
  paymentPlanCalculationResponse: Seq[PaymentPlanInstalmentResponse]
)

object PaymentPlanSummaryResponse {
  implicit val paymentPlanResponseFormat: OFormat[PaymentPlanSummaryResponse] = Json.format[PaymentPlanSummaryResponse]

}
