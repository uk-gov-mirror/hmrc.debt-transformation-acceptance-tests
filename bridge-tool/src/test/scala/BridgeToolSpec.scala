package test

import io.circe._
import io.circe.generic.auto._
import io.circe.parser._
import io.circe.syntax._
import main._
import utest._
import errors.BridgeToolError

import java.time.LocalDateTime

object BridgeToolTests extends TestSuite {

  val tests = Tests {
    test("parse a RequestDetail") {
      val raw = scala.io.Source.fromFile("src/test/resources/unprocessed-requests.json").mkString
      val obj = decode[List[RequestDetail]](raw)
      assert(obj.isRight)
    }

    test("parse a RequestDetail with a missing method") {
      val raw = scala.io.Source.fromFile("src/test/resources/unprocessed-requests.json").mkString
      val obj = decode[List[RequestDetail]](raw)

      assert(obj.isRight)

      val details = obj.right.get
      val methods = details.map(extractMethod)
      val expected = List(
        Right("POST"),
        Right("POST"),
        Right("GET"),
        Left(BridgeToolError.BadMethod(details.last))
      )

      assert(methods == expected)
    }
  }

}
