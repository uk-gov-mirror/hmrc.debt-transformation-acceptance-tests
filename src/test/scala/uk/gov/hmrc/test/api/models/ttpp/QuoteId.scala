package uk.gov.hmrc.test.api.models.ttpp

final case class QuoteId(value: String) extends AnyVal

object QuoteId extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(QuoteId.apply, QuoteId.unapply)
}
