/*
 * Copyright 2020 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package uk.gov.hmrc.test.api.cucumber.stepdefs

import cucumber.api.scala.{EN, ScalaDsl}
import io.cucumber.datatable.DataTable
import org.joda.time.LocalDate
import org.scalatest.Matchers
import org.scalatest.concurrent.Eventually
import play.api.libs.ws.StandaloneWSResponse
import uk.gov.hmrc.test.api.requests.SuppressionRulesRequests.{addSuppressionRules, addSuppressionToInstalmentCalculation, addSuppressions}
import uk.gov.hmrc.test.api.utils.ScenarioContext

class commonSteps extends ScalaDsl with EN with Eventually with Matchers {

  Given("suppression data has been created") { (dataTable: DataTable) =>
    addSuppressions(dataTable)
  }

  Given("a suppression with ID (.*), code (.*), reason (.*) and description (.*) has been applied from (.*) for (.*) months") { (id: String, code: String, reason: String, description: String, fromDate: String, durationMonths: Int) =>
    val fromDateParsed = if(fromDate == "yesterday"){
      LocalDate.now().minusDays(1)
    } else if(fromDate == "today"){
      LocalDate.now()
    } else LocalDate.parse(fromDate)
    addSuppressionToInstalmentCalculation(id, code, reason, description, fromDateParsed, durationMonths)
  }

  Given("suppression rules have been created") { (dataTable: DataTable) =>
    addSuppressionRules(dataTable)
  }

  Then("service returns response code (.*)") { (expectedCode: Int) =>
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    response.status should be(expectedCode)
  }

  And("service returns error message (.*)") { (expectedMessage: String) =>
    val response: StandaloneWSResponse = ScenarioContext.get("response")
    val responseBody                   = response.body.stripMargin
    print("response message*****************************" + responseBody)
    responseBody should be(expectedMessage)
  }

}
