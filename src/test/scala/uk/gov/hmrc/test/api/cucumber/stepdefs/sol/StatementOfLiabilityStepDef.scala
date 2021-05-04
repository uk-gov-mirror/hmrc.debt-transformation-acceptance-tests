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

package uk.gov.hmrc.test.api.cucumber.stepdefs.sol

import io.cucumber.datatable.DataTable
import uk.gov.hmrc.test.api.cucumber.stepdefs.BaseStepDef
import uk.gov.hmrc.test.api.requests.TestData
import uk.gov.hmrc.test.api.utils.ScenarioContext

class StatementOfLiabilityStepDef extends BaseStepDef {


  Given("""debt details""") { (dataTable: DataTable) =>
    val asMapTransposed   = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem         = false
    var debtDetails: String = null

    try ScenarioContext.get("debtDetails")
    catch { case e: Exception => firstItem = true }

    val debtDetailsTestfile = getBodyAsString("debtDetailsTestfile")
      .replaceAll("<REPLACE_solType>", "solType")
      .replaceAll("<REPLACE_debtType>", asMapTransposed.get("debtType"))
      .replaceAll("<REPLACE_dutyType>", asMapTransposed.get("dutyType"))
      .replaceAll("<REPLACE_mainTrans>", asMapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asMapTransposed.get("subTrans"))


    if (firstItem == true) { debtDetails = debtDetailsTestfile }
    else { debtDetails = ScenarioContext.get("debtDetails").toString.concat(",").concat(debtDetailsTestfile) }
print("requst json ::::::::::::::::::::::::::::::::::::" +debtDetails)
    ScenarioContext.set(
      "debtDetails",
      debtDetails
    )
  }

  def getBodyAsString(variant: String): String =
    TestData.loadedFiles(variant)
}
