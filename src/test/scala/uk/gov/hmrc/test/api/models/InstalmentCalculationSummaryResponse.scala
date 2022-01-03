package uk.gov.hmrc.test.api.models

/*
 * Copyright 2021 HM Revenue & Customs
 *
 */

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

final case class InstalmentCalculationSummaryResponse(
  dateOfCalculation: LocalDate,
  numberOfInstalments: Long,
  planInterest: Int,
  interestAccrued: Int,
  totalInterest: Int,
  duration: Long,
  instalments: Seq[InstalmentResponse]
)

object InstalmentCalculationSummaryResponse {
  implicit val instalmentCalculationSummaryResponseFormat: OFormat[InstalmentCalculationSummaryResponse] =
    Json.format[InstalmentCalculationSummaryResponse]

}
