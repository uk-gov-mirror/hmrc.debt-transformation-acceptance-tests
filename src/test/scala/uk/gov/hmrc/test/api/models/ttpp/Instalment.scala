package uk.gov.hmrc.test.api.models.ttpp
import play.api.libs.json.Json

case class Instalment(
  debtItemChargeId: String,
  dueDate: String,
  amountDue: BigDecimal,
  expectedPayment: BigDecimal,
  interestRate: Double,
  instalmentNumber: Int,
  instalmentInterestAccrued: BigDecimal,
  instalmentBalance: BigDecimal
)

object Instalment {
  implicit val format = Json.format[Instalment]
}
