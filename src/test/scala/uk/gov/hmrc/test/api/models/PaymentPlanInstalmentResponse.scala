package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */
import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

final case class PaymentPlanInstalmentResponse(
  debtId: String,
  instalmentNumber: Int,
  dueDate: LocalDate,
  amountDue: Int,
  instalmentBalance: Int,
  instalmentInterestAccrued: Int,
  expectedPayment: Int,
  intRate: Double
)
object PaymentPlanInstalmentResponse {
  implicit val paymentPlanInstalmentResponseFormat: OFormat[PaymentPlanInstalmentResponse] = Json.format
}
