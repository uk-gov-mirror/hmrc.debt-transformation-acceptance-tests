/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed trait RegimeType extends EnumEntry

object RegimeType extends Enum[RegimeType] with PlayJsonEnum[RegimeType] {
  val values: immutable.IndexedSeq[RegimeType] = findValues

  case object DRIER extends RegimeType

  case object TPSS extends RegimeType

  case object ChildBenefits extends RegimeType

}
