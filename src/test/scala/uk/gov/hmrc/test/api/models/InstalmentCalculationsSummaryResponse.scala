package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

case class InstalmentCalculationsSummaryResponse(
                                                  dateOfCalculation: LocalDate,
                                                  numberOfInstalments: Long,
                                                  interestAccrued: BigDecimal,
                                                  planInterest: BigDecimal,
                                                  totalInterest: BigDecimal,
                                                  duration: Long,
                                                  instalments: Seq[InstalmentResponse]
                                                )

object InstalmentCalculationsSummaryResponse {
  implicit val instalmentCalculationSummaryResponseFormat: OFormat[InstalmentCalculationsSummaryResponse] = Json.format[InstalmentCalculationsSummaryResponse]
}
