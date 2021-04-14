package uk.gov.hmrc.test.api.cucumber.hooks

import com.typesafe.scalalogging.LazyLogging
import cucumber.api.scala.ScalaDsl
import uk.gov.hmrc.test.api.utils.ScenarioContext
import uk.gov.hmrc.test.api.requests.HelloWorldRequests

class IfsRuleHook extends ScalaDsl with LazyLogging{

  Before() { _ =>
    ScenarioContext.reset()

    //DTD-216: Workaround to load the rule set
    val response = HelloWorldRequests.getInterestForecastingService("/hello-world")
    Thread.sleep(2000)
  }

  After() { scenario =>
    if (scenario.isFailed) {
      println("")
      logger.info(s"*********** Ifs rule in database after running ${scenario.getName} ***********")

    }
  }
}
