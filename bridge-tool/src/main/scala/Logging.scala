package logging

private val infoPrinter = pprint.PPrinter.BlackWhite
private val errorPrinter = pprint.PPrinter.BlackWhite

def info(input: Any*): Unit =
  input.map(infoPrinter.apply(_)).foreach(Console.out.println)

def error(input: Any*): Unit =
  input.map(errorPrinter.apply(_)).foreach(Console.err.println)
