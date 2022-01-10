package uk.gov.hmrc.test.api.models.ttpp

import java.time.LocalDate

import play.api.libs.json.Json

case class UpdatePlanResponse(
  customerReference: String,
  planId: String,
  planStatus: String,
  planUpdatedDate: LocalDate
)

object UpdatePlanResponse {
  implicit val format = Json.format[UpdatePlanResponse]
}
