package uk.gov.hmrc.test.api.models.ttpp

case class Duration(value: Int) extends AnyVal

object Duration extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(Duration.apply, Duration.unapply)
}
