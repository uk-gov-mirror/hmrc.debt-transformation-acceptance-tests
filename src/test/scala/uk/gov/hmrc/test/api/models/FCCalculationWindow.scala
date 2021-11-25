/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import java.time.LocalDate

import play.api.libs.json.{Json, OFormat}

case class FCCalculationWindow(
                                periodFrom: LocalDate,
                                periodTo: LocalDate,
                                numberOfDays: Int,
                                interestRate: Double,
                                interestDueDailyAccrual: Int,
                                interestDueWindow: Int,
                                amountOnIntDueWindow: Int,
                                unpaidAmountWindow: Int,
                                suppressionApplied: Option[SuppressionApplied]

                                //                                suppressionDateFrom: Option[LocalDate],
//                                suppressionDateTo: Option[LocalDate],
//                                suppressionReason: Option[SuppressionReason],
//                                suppressionReasonDesc: Option[String],
//                                suppressionPostcode: Option[String]
                              //suppressionApplied: Option[SuppressionApplied]
                            )

//case class SuppressionApplied(reason: String, description: String, code: String)
//
//object SuppressionApplied {
//  implicit val formatCalculationWindow: OFormat[SuppressionApplied] = Json.format[SuppressionApplied]
//}

object FCCalculationWindow {
  implicit val formatDebtItemCalculationWindow: OFormat[FCCalculationWindow] =
    Json.format[FCCalculationWindow]
}
