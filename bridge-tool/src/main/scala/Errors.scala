package errors

import requests.Response
import main.RequestDetail

sealed abstract class BridgeToolError

object BridgeToolError {

  final case class Token(env: String, error: Response) extends BridgeToolError
  final case class Connectivity(env: String, error: Response) extends BridgeToolError
  final case class MissingURL(badDetails: RequestDetail) extends BridgeToolError
  final case class BadMethod(badDetails: RequestDetail) extends BridgeToolError
  final case class Decode(badObject: String) extends BridgeToolError

}
