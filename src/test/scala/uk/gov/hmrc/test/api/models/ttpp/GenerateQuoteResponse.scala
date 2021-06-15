package uk.gov.hmrc.test.api.models.ttpp
import java.time.LocalDate

import play.api.libs.json.Json

case class Instalment(dutyId: String,
                      debtId: String,
                      dueDate: LocalDate,
                      amountDue: BigDecimal,
                      interestRate: Double,
                      instalmentNumber: Int)

object Instalment {
  implicit val format = Json.format[Instalment]
}

case class GenerateQuoteResponse(quoteReference: String,
                                 customerReference: String,
                                 quoteType: String,
                                 instalments: List[Instalment],
                                 numberOfInstalments: String,
                                 totalDebtAmount: BigDecimal,
                                 totalInterest: Double)

object GenerateQuoteResponse {
  implicit val format = Json.format[GenerateQuoteResponse]
}
