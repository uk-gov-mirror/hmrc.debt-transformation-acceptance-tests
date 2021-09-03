package uk.gov.hmrc.test.api.models.ttpp

import play.api.libs.json.Json

final case class CreatePlanRequest(
                                    customerReference: CustomerReference,
                                    planId: PlanId,
                                    paymentMethod: String,
                                    paymentReference: String,
                                    thirdPartyBank: Boolean,
                                    instalments: Seq[Instalment],
                                    numberOfInstalments: String,
                                    totalDebtAmount: BigDecimal,
                                    totalInterest: Double
                                  )

object CreatePlanRequest {
  implicit val format = Json.format[CreatePlanRequest]
}


