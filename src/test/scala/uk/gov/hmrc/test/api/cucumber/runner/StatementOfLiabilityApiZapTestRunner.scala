package uk.gov.hmrc.test.api.cucumber.runner

import com.typesafe.config.{Config, ConfigFactory}
import org.scalatest.WordSpec

class StatementOfLiabilityApiZapTestRunner extends WordSpec with ZapTest {
  val customConfig: Config =
    ConfigFactory.load().getConfig("StatementOfLiabilityApi")

  override val zapConfiguration: ZapConfiguration = new ZapConfiguration(customConfig)

  "Kicking off the zap scan" should {
    "should complete successfully" in {
      triggerZapScan()
    }
  }

}