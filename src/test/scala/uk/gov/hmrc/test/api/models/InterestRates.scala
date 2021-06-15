package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate


case class InterestRate(date: LocalDate, interestRate: Double)

object InterestRate {
  implicit val format : OFormat[InterestRate] = Json.format
}
case class InterestRates(referenceId: Int, interestRate: Seq[InterestRate])
object InterestRates {
  implicit val format : OFormat[InterestRates] = Json.format
}