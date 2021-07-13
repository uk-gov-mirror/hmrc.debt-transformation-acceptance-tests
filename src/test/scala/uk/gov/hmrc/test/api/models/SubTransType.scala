/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed abstract class SubTransType(override val entryName: String) extends EnumEntry

object SubTransType extends Enum[SubTransType] with PlayJsonEnum[SubTransType] {
  val values: immutable.IndexedSeq[SubTransType] = findValues


  case object ChBDebt extends SubTransType("7006")
  case object GuardiansGBDebt extends SubTransType("7010")
  case object GuardiansNIDebt extends SubTransType("7011")
  case object ChBMigratedDebt extends SubTransType("7012")
  case object GuardiansGBChBMigratedDebt extends SubTransType("7014")
  case object GuardiansNIChBMigratedDebt extends SubTransType("7013")
  case object IT extends SubTransType("1000")
  case object NICGB extends SubTransType("1020")
  case object NICNI extends SubTransType("1025")
  case object HIPG extends SubTransType("1180")
  case object INTIT extends SubTransType("2000")
  case object TGPEN extends SubTransType("1090")

}

