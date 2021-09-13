package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */
import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

case class PaymentPlan(
  ddebtId: String,
  debtAmount: BigDecimal,
  instalmentAmount: BigDecimal,
  paymentFrequency: Frequency,
  instalmentDate: LocalDate,
  quoteDate: LocalDate,
  mainTrans: MainTransType,
  subTrans: SubTransType,
  interestAccrued: Int,
  initialPaymentDate: Option[LocalDate] = None,
  initialPaymentAmount: Option[BigDecimal] = None

)

object PaymentPlan {
  implicit val paymentPlanFormat: OFormat[PaymentPlan] = Json.format[PaymentPlan]
}
