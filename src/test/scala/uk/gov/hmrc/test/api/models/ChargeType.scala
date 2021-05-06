/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed trait ChargeType extends EnumEntry

object ChargeType extends Enum[ChargeType] with PlayJsonEnum[ChargeType] {
  val values: immutable.IndexedSeq[ChargeType] = findValues

  case object IT extends ChargeType

  case object NI extends ChargeType

  case object HIPG extends ChargeType // Health in pregnancy grant

  case object INT_IT extends ChargeType

  case object TG_PEN extends ChargeType

  case object ChildBenefitDebt extends ChargeType

  case object GuardiansAllowanceGBDebt extends ChargeType

  case object GuardiansAllowanceNIDebt extends ChargeType

  case object ChildBenefitMigratedDebt extends ChargeType

  case object GuardiansAllowanceMigratedGBDebt extends ChargeType

  case object GuardiansAllowanceMigratedNIDebt extends ChargeType

}
