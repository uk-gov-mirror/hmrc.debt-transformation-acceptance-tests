package uk.gov.hmrc.test.api.models.ttpp

final case class QuoteReference(value: String) extends AnyVal

object QuoteReference extends ValueTypeFormatter {
  implicit val format = valueTypeFormatter(QuoteReference.apply, QuoteReference.unapply)
}
