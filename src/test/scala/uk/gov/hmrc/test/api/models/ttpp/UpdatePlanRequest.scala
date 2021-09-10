package uk.gov.hmrc.test.api.models.ttpp

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}
import play.api.libs.json.Json

final case class CancellationReason(value: String) extends AnyVal

object CancellationReason extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(CancellationReason.apply, CancellationReason.unapply)
}

sealed abstract class PaymentMethod(override val entryName: String) extends EnumEntry

object PaymentMethod extends Enum[PaymentMethod] with PlayJsonEnum[PaymentMethod] {
  val values: scala.collection.immutable.IndexedSeq[PaymentMethod] = findValues

  case object DirectDebit extends PaymentMethod("directDebit")
  case object Bacs extends PaymentMethod("BACS")
  case object Cheque extends PaymentMethod("cheque")
  case object CardPayment extends PaymentMethod("cardPayment")
}

final case class PaymentReference(value: String) extends AnyVal

object PaymentReference extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(PaymentReference.apply, PaymentReference.unapply)
}

final case class UpdateType(value: String) extends AnyVal

object UpdateType extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(UpdateType.apply, UpdateType.unapply)
}

final case class UpdatePlanRequest(
  customerReference: CustomerReference,
  planId: PlanId,
  updateType: UpdateType,
  cancellationReason: CancellationReason,
  paymentMethod: PaymentMethod,
  paymentReference: PaymentReference,
  thirdPartyBank: Boolean
)

object UpdatePlanRequest {
  implicit val format = Json.format[UpdatePlanRequest]
}
