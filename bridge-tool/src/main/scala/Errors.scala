package errors

import requests.Response
import main.RequestDetail
import io.circe.{ Error => CirceError }

sealed abstract class BridgeToolError {
  import BridgeToolError._

  def errorMessage: String =
    this match {

      case Token(error: Response) =>
        s"Failed get token; got: $error"

      case Connectivity(env: String, error: Response) =>
        s"Failed to connect to $env; got: $error"

      case MissingURL(badDetails: RequestDetail) =>
        s"Missing URL from request details; details: $badDetails"

      case BadMethod(badDetails: RequestDetail) =>
        badDetails.method match {
          case Some(badMethod) =>
            s"Bad method from details: $badDetails; method $badMethod is not POST, PUT, or GET"
          case None =>
            s"Bad method from details: $badDetails; missing http method"
        }

      case Decode(badObject: String, error: CirceError) =>
        s"failed to decode $badObject; got: $error"

      case NoRequestsToProcess =>
        s"No available requests."

    }

}

object BridgeToolError {

  type Result[A] = Either[BridgeToolError, A]

  final case class Token(error: Response) extends BridgeToolError
  final case class Connectivity(env: String, error: Response) extends BridgeToolError
  final case class MissingURL(badDetails: RequestDetail) extends BridgeToolError
  final case class BadMethod(badDetails: RequestDetail) extends BridgeToolError
  final case class Decode(badObject: String, error: CirceError) extends BridgeToolError
  case object NoRequestsToProcess extends BridgeToolError

}
