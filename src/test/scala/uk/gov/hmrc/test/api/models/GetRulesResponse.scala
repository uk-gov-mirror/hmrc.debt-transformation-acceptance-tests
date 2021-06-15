package uk.gov.hmrc.test.api.models

import play.api.libs.json.{Json, OFormat}

import java.time.LocalDate

case class RuleCollection(rules: List[String], id: String, enabled: Boolean, version: Int, createdAt: LocalDate)

case class GetRulesResponse(rules: Seq[RuleCollection])



object GetRulesResponse {

  implicit val getRuleCollectionFormat: OFormat[RuleCollection] = Json.format
  implicit val getRulesResponseFormat: OFormat[GetRulesResponse] = Json.format
}