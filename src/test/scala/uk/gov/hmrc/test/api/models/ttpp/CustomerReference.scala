package uk.gov.hmrc.test.api.models.ttpp

final case class CustomerReference(value: String) extends AnyVal

object CustomerReference extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(CustomerReference.apply, CustomerReference.unapply)
}

