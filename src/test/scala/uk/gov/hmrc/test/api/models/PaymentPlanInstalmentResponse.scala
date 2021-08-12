package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */
import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

final case class PaymentPlanInstalmentResponse(
  serialNo: Int,
  paymentDueDate: LocalDate,
  amountDue: Int,
  uniqueDebtId: String,
  balance: Int,
  interestDue: Int,
  totalPaidAmount: Int,
  intRate: Double
)
object PaymentPlanInstalmentResponse {
  implicit val paymentPlanInstalmentResponseFormat: OFormat[PaymentPlanInstalmentResponse] = Json.format
}
