package uk.gov.hmrc.test.api.models.ttpp

import enumeratum.{Enum, EnumEntry, PlayJsonEnum}
import play.api.libs.json.Json
import uk.gov.hmrc.test.api.models.{DebtItem, Frequency}
import java.time.LocalDate
import scala.collection.immutable

sealed abstract class ChannelIdentifier(override val entryName: String) extends EnumEntry

object ChannelIdentifier extends Enum[ChannelIdentifier] with PlayJsonEnum[ChannelIdentifier] {
  val values: immutable.IndexedSeq[ChannelIdentifier] = findValues

  case object Advisor extends ChannelIdentifier("advisor")
  case object SelfService extends ChannelIdentifier("selfService")
}

final case class PlanToGenerateQuote(
  quoteType: QuoteType,
  quoteDate: LocalDate,
  instalmentStartDate: LocalDate,
  instalmentPaymentAmount: BigDecimal,
  frequency: Frequency,
  duration: Duration,
  initialPaymentAmount: BigDecimal,
  initialPaymentDate: LocalDate,
  paymentPlanType: PaymentPlanType
)

object PlanToGenerateQuote {
  implicit val format = Json.format[PlanToGenerateQuote]
}

final case class GenerateQuoteRequest(
  customerReference: CustomerReference,
  channelIdentifier: ChannelIdentifier,
  plan: PlanToGenerateQuote,
  customerPostCodes: List[CustomerPostCode],
  debtItems: List[DebtItem]
)

object GenerateQuoteRequest {
  implicit val format = Json.format[GenerateQuoteRequest]
}
