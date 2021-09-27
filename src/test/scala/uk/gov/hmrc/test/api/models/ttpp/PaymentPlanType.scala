package uk.gov.hmrc.test.api.models.ttpp

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed abstract class InstalmentCalculationType(override val entryName: String) extends EnumEntry

object InstalmentCalculationType extends Enum[InstalmentCalculationType] with PlayJsonEnum[InstalmentCalculationType] {
  val values: immutable.IndexedSeq[InstalmentCalculationType] = findValues

  case object TimeToPay extends InstalmentCalculationType("timeToPay")
  case object InstalmentOrder extends InstalmentCalculationType("instalmentOrder")
  case object ChildBenefits extends InstalmentCalculationType("childBenefits")
  case object FieldCollections extends InstalmentCalculationType("fieldCollections")
}
