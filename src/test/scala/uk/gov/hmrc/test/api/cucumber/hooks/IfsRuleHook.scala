package uk.gov.hmrc.test.api.cucumber.hooks

import com.typesafe.scalalogging.LazyLogging
import cucumber.api.scala.ScalaDsl
import uk.gov.hmrc.test.api.utils.ScenarioContext

class IfsRuleHook extends ScalaDsl with LazyLogging{

  Before() { _ =>
    ScenarioContext.reset()
  }

  After() { scenario =>
    if (scenario.isFailed) {
      println("")
      logger.info(s"*********** Ifs rule in database after running ${scenario.getName} ***********")

    }
  }
}
