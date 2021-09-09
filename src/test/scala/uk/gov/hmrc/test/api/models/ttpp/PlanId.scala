package uk.gov.hmrc.test.api.models.ttpp

final case class PlanId(value: String) extends AnyVal

object PlanId extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(PlanId.apply, PlanId.unapply)
}
