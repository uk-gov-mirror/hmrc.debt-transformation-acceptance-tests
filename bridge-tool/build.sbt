name := "bridge-tool"
scalaVersion := "3.1.1"
version := "1.0"

lazy val compileDependencies = List(
  "com.lihaoyi" %% "requests" % "0.7.0",
  "com.lihaoyi" %% "pprint" % "0.7.0",
  "io.circe" %% "circe-core" % "0.14.1",
  "io.circe" %% "circe-generic" % "0.14.1",
  "io.circe" %% "circe-parser" % "0.14.1",
)

lazy val testDependencies = List(
  "com.lihaoyi" %% "utest" % "0.7.10" % "test"
)

libraryDependencies ++= compileDependencies ++ testDependencies

scalacOptions ++= Seq(
  "-Xfatal-warnings",
  "-Ycheck-all-patmat",
)

testFrameworks += new TestFramework("utest.runner.Framework")
