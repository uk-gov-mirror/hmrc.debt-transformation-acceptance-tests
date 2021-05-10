package uk.gov.hmrc.test.api.requests

import play.api.libs.json.Json
import uk.gov.hmrc.test.api.client.WsClient
import uk.gov.hmrc.test.api.utils.{BaseUris, RandomValues}

trait BaseRequests extends RandomValues with BaseUris {

  def createBearerToken(
    enrolments: Seq[String] = Seq(),
    userType: String = getRandomAffinityGroup,
    utr: String = "123456789012"
  ): String = {
    val json =
      Json.obj(
        "affinityGroup"      -> userType,
        "credentialStrength" -> "strong",
        "confidenceLevel"    -> 50,
        "credId"             -> "test",
        "enrolments"         -> enrolments.map(key =>
          Json.obj(
            "key"         -> key,
            "identifiers" -> Json.arr(
              Json.obj(
                "key"   -> "UTRNumber",
                "value" -> utr
              )
            ),
            "state"       -> "Activated"
          )
        )
      )

    val response                          = WsClient.post(s"$authLoginApiUri/session/login", Map("Content-Type" -> "application/json"), json)
    val authHeader: (String, Seq[String]) = response.headers
      .filter(header => header._1.equalsIgnoreCase("Authorization"))
      .head

    val authBearerToken = authHeader._2.head.replace("Bearer ", "")
    authBearerToken

  }

}
