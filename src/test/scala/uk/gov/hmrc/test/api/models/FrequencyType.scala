/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed abstract class FrequencyType(override val entryName: String) extends EnumEntry

object FrequencyType extends Enum[FrequencyType] with PlayJsonEnum[FrequencyType] {
  val values: immutable.IndexedSeq[FrequencyType] = findValues

  case object Single extends FrequencyType("Single")
  case object Weekly extends FrequencyType("Weekly")
  case object BiWeekly extends FrequencyType("2-Weekly")
  case object FourWeekly extends FrequencyType("4-Weekly")
  case object Monthly extends FrequencyType("Monthly")
  case object Quarterly extends FrequencyType("Quarterly")
  case object HalfYearly extends FrequencyType("HalfYearly")
  case object Annually extends FrequencyType("Annually")

}
