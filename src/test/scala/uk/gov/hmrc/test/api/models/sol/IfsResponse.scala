/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models.sol

import play.api.libs.json._

import java.time.LocalDate

final case class DebtCalculationWindow(periodFrom: LocalDate,
                                 periodTo: LocalDate,
                                 numberOfDays: Long,
                                 interestRate: Double,
                                 interestDueDailyAccrual: Int,
                                 interestDueWindow: Int,
                                 amountOnIntDueWindow: Int,
                                 unpaidAmountWindow: Int,
                                 breathingSpaceApplied: Boolean)

object DebtCalculationWindow {
  implicit val debtCalculationWindowWrite: OFormat[DebtCalculationWindow] = Json.format[DebtCalculationWindow]
}

final case class DebtCalculationItem(
                                debtID: String,
                                interestBearing: Boolean,
                                numberOfChargeableDays: Long,
                                interestDueDailyAccrual: Int,
                                interestDueDutyTotal: Int,
                                amountOnIntDueDuty: Int,
                                totalAmountIntDuty: Int,
                                unpaidAmountDuty: Int,
                                interestOnlyIndicator: Boolean,
                                calculationWindows: Seq[DebtCalculationWindow]
                              )

object DebtCalculationItem {
  implicit val debtCalculationItemWrite: OFormat[DebtCalculationItem] = Json.format[DebtCalculationItem]
}

final case class IfsResponse(
                        combinedDailyAccrual: Int,
                        unpaidAmountTotal: Int,
                        interestDueCallTotal: Int,
                        amountIntTotal: Int,
                        amountOnIntDueTotal: Int,
                        debtCalculations: Seq[DebtCalculationItem]
                                  )

object IfsResponse {

}
