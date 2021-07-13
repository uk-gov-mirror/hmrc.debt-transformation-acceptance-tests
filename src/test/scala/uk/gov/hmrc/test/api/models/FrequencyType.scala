/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed abstract  class FrequencyType(override val entryName: String) extends  EnumEntry

object FrequencyType extends Enum[FrequencyType] with PlayJsonEnum[FrequencyType]{
  val values: immutable.IndexedSeq[FrequencyType] = findValues

  case object Monthly extends FrequencyType("monthly")
  case object Weekly extends FrequencyType("weekly")
  case object BiWeekly extends FrequencyType("bi-weekly")

}
