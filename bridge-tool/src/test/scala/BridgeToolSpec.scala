package test

import utest._
import main._
import main.OptionPickler._

object BridgeToolTests extends TestSuite {

  val tests = Tests {
    test("parse a RequestDetail") {
      import main.RequestDetail.rw

      val raw: String = scala.io.Source.fromFile("src/test/resources/unprocessed-requests.json").mkString
      val obj = read[List[RequestDetail]](raw)
    }
  }

}

