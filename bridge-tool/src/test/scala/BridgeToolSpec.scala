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

    test("parse more than one RequestDetail, one with a BadMethod") {
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

    test("parse a RequestDetail with a missing method") {
      val raw = scala.io.Source.fromFile("src/test/resources/requests-with-missing-method.json").mkString
      val obj = decode[List[RequestDetail]](raw)

      assert(obj.isRight)

      val details = obj.right.get
      val methods = details.map(extractMethod)
      val expected = List(Right("POST"))

      assert(methods == expected)
    }

    test("parse a RequestDetail with a missing URL") {
      val raw = scala.io.Source.fromFile("src/test/resources/requests-with-missing-url.json").mkString
      val obj = decode[List[RequestDetail]](raw)

      assert(obj.isRight)

      val details = obj.right.get
      val methods = details.map(extractURL)
      val expected = List(Left(BridgeToolError.MissingURL(details.head)))

      assert(methods == expected)
    }

    test("process the next request") {
      val raw = scala.io.Source.fromFile("src/test/resources/unprocessed-requests.json").mkString
      val obj = decode[List[RequestDetail]](raw)

      assert(obj.isRight)

      val details = obj.right.get
      val methods = nextProcessableRequest(details)
      val expected = Right(details.head)

      assert(methods == expected)
    }

    test("return NoRequestsToProcess for an empty list") {

      val details = List.empty
      val methods = nextProcessableRequest(details)
      val expected = Left(BridgeToolError.NoRequestsToProcess)

      assert(methods == expected)
    }

  }

}
