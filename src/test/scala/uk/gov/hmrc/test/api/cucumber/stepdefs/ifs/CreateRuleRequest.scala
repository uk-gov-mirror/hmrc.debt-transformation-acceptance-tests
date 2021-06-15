package uk.gov.hmrc.test.api.cucumber.stepdefs.ifs

import play.api.libs.json.{Json, OFormat}

case class CreateRuleRequest(settings: List[String])

object CreateRuleRequest {
  implicit val createRulesRequestFormat: OFormat[CreateRuleRequest]  = Json.format
}