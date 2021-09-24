package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

case class InstalmentCalculationInstalment(
                                            serialNo: Int,
                                            paymentDueDate: LocalDate,
                                            amountDue: BigDecimal,
                                            uniqueDebtId: String,
                                            balance: BigDecimal,
                                            instalmentInterestAccrued: BigDecimal,
                                            totalPaidAmount: BigDecimal,
                                            intRate: Double
                                          )

object InstalmentCalculationInstalment {
  implicit val paymentPlanInstalmentFormat: OFormat[InstalmentCalculationInstalment] = Json.format[InstalmentCalculationInstalment]
}
