/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

case class FCDebtCalculation(

                              interestBearing: Boolean,
                              interestDueDailyAccrual: Int,
                              interestDueDutyTotal: Int,
                              amountOnIntDueDuty: Int,
                              totalAmountIntDuty: Int,
                              unpaidAmountDuty: Int,
                              calculationWindows: List[FCCalculationWindow] = Nil
                          )


object FCDebtCalculation {
  implicit val formatDebtCalculation: OFormat[FCDebtCalculation] = Json.format[FCDebtCalculation]
}

