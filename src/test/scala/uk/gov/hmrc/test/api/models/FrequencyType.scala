/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed abstract class Frequency(override val entryName: String) extends EnumEntry

object Frequency extends Enum[Frequency] with PlayJsonEnum[Frequency] {
  val values: immutable.IndexedSeq[Frequency] = findValues

  case object Single extends Frequency("single")
  case object Weekly extends Frequency("weekly")
  case object BiWeekly extends Frequency("BiWeekly")
  case object FourWeekly extends Frequency("4Weekly")
  case object Monthly extends Frequency("monthly")
  case object Quarterly extends Frequency("quarterly")
  case object HalfYearly extends Frequency("HalfYearly")
  case object Annually extends Frequency("annually")
}
