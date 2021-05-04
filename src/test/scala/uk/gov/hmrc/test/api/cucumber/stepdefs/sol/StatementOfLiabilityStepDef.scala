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
import play.twirl.api.TwirlHelperImports.twirlJavaCollectionToScala
import uk.gov.hmrc.test.api.cucumber.stepdefs.BaseStepDef
import uk.gov.hmrc.test.api.requests.{RequestSolDetails, TestData}
import uk.gov.hmrc.test.api.utils.ScenarioContext

class StatementOfLiabilityStepDef extends BaseStepDef {


  Given("""debt details""") { (dataTable: DataTable) =>
    val asMapTransposed   = dataTable.transpose().asMap(classOf[String], classOf[String])
    var firstItem         = false
    var debtDetails: String = null

    try ScenarioContext.get("debtDetails")
    catch { case e: Exception => firstItem = true }

    val debtDetailsTestfile = getBodyAsString("debtDetailsTestfile")
      .replaceAll("<REPLACE_solType>", asMapTransposed.get("solType"))
      .replaceAll("<REPLACE_uniqueItemReference>", asMapTransposed.get("debtId"))
      .replaceAll("<REPLACE_mainTrans>", asMapTransposed.get("mainTrans"))
      .replaceAll("<REPLACE_subTrans>", asMapTransposed.get("subTrans"))

    if (firstItem == true) { debtDetails = debtDetailsTestfile }
    else { debtDetails = ScenarioContext.get("debtDetails").toString.concat(",").concat(debtDetailsTestfile)}

    ScenarioContext.set("debtDetails", debtDetails)
    print("reqeust json ::::::::::::::::::::::::::::::::::::" +debtDetails)
  }

  def getBodyAsString(variant: String): String = {
    TestData.loadedFiles(variant)
  }

  And("""add debt item chargeIDs to the debt""") {(dataTable: DataTable)=>
    val asMapTransposed = dataTable.asMaps(classOf[String], classOf[String])
    var dutyChargeIds        = ""

    asMapTransposed.zipWithIndex.foreach { case (dutyId, index) =>
      dutyChargeIds = dutyChargeIds.concat(dutyId.get("dutyId"))
      if (index + 1 < asMapTransposed.size) dutyChargeIds = dutyChargeIds.concat(",")
    }
    val jsonWithDutyChargeId = ScenarioContext.get("debtDetails").toString.replaceAll("<REPLACE_debtItemChargeIDs>", dutyChargeIds)
    ScenarioContext.set("debtDetails", jsonWithDutyChargeId)
  }

  When("""a debt statement of liability is requested""") {
    val request = ScenarioContext.get("debtDetails").toString

    val response =
      RequestSolDetails.getStatementOfLiability(request)
    println(s"RESP --> ${response.body}")
    ScenarioContext.set("response", response)
  }


}
