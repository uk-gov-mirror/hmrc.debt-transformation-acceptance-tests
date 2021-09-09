package uk.gov.hmrc.test.api.models.ttpp

import play.api.libs.json.Json

import java.time.LocalDate

final case class PostCode(value: String) extends AnyVal

object PostCode extends ValueTypeFormatter {
  implicit val format =
    valueTypeFormatter(PostCode.apply, PostCode.unapply)
}

final case class CustomerPostCode(addressPostcode: PostCode, postcodeDate: LocalDate)

object CustomerPostCode {
  implicit val format = Json.format[CustomerPostCode]
}
