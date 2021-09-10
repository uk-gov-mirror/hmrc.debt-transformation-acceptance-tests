package uk.gov.hmrc.test.api.models.ttpp

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed abstract class PaymentPlanType(override val entryName: String) extends EnumEntry

object PaymentPlanType extends Enum[PaymentPlanType] with PlayJsonEnum[PaymentPlanType] {
  val values: immutable.IndexedSeq[PaymentPlanType] = findValues

  case object TimeToPay extends PaymentPlanType("timeToPay")
  case object InstalmentOrder extends PaymentPlanType("instalmentOrder")
  case object ChildBenefits extends PaymentPlanType("childBenefits")
  case object FieldCollections extends PaymentPlanType("fieldCollections")
}
