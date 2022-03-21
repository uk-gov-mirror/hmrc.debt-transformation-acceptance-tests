package logging

private val errorPrinter = pprint.copy(colorLiteral = fansi.Color.Red)

def info(input: String): Unit = {
  val formatted = pprint.apply(input)
  Console.out.println(formatted)
}

def error(input: String): Unit = {
  val formatted = errorPrinter.apply(input)
  Console.err.println(formatted)
}
