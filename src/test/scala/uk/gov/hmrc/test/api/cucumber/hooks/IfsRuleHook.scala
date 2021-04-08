package uk.gov.hmrc.test.api.cucumber.hooks

import com.typesafe.scalalogging.LazyLogging
import cucumber.api.scala.ScalaDsl
import uk.gov.hmrc.test.api.conf.TestConfiguration
import uk.gov.hmrc.test.api.requests.Helper

class IfsRuleHook extends ScalaDsl with LazyLogging{

  Before() { _ =>
    if (!TestConfiguration.env.equals("qa")) {
      Helper.createDebtCalculationRule()
    }
  }

  After() { scenario =>
    if (scenario.isFailed) {
      println("")
      logger.info(s"*********** Ifs rule in database after running ${scenario.getName} ***********")

    }
  }
}