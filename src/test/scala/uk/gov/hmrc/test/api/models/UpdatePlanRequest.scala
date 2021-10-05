package uk.gov.hmrc.test.api.models

import play.api.libs.json.Json

case class UpdatePlanRequest (customerReference: String,
                              planId: String,
                              updateType: String,
                              planStatus: String,
                              completeReason: Option[String],
                              cancellationReason: Option[String],
                              thirdPartyBank: Option[Boolean],
                              payments: Option[List[PaymentInformation]]
                             )
final case class PaymentInformation(paymentMethod: String, paymentReference: String)

object PaymentInformation {
  implicit val formats = Json.format[PaymentInformation]
}
object UpdatePlanRequest {
  implicit val formats = Json.format[UpdatePlanRequest]
}