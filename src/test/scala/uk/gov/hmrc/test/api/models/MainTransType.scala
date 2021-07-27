/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}

import scala.collection.immutable

sealed abstract class MainTransType(override val entryName: String) extends EnumEntry

object MainTransType extends Enum[MainTransType] with PlayJsonEnum[MainTransType] {
  val values: immutable.IndexedSeq[MainTransType] = findValues

  case object ChBDebt extends MainTransType("5330")
  case object ChBMigratedDebt extends MainTransType("5350")
  case object DrierIt extends MainTransType("1085")
  case object TPSSAFT extends MainTransType("1511")
  case object TPSSFailureToSubmit extends MainTransType("1515")
  case object TPSSPenalty extends MainTransType("1520")
  case object TPSSAccTaxAssessment extends MainTransType("1525")
  case object TPSSAFTAssessment extends MainTransType("1526")
  case object TPSSSchemaSanction extends MainTransType("1530")
  case object TPSSSchemaSanctionNT extends MainTransType("1531")
  case object TPSSLumpSum extends MainTransType("1535")
  case object TPSSLumpSumINT extends MainTransType("1536")
  case object TPSSUnreportedLiability extends MainTransType("1540")
  case object TPSSUnreportedLiabilityINT extends MainTransType("1541")
  case object TPSSContractSettlement extends MainTransType("1545")
  case object TPSSContractSettlementINT extends MainTransType("1546")
}
