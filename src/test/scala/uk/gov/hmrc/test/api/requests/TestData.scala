package uk.gov.hmrc.test.api.requests

import com.typesafe.scalalogging.LazyLogging
import org.apache.commons.io.FileUtils
import scala.collection.JavaConverters._
import java.io.File
import scala.io.Source

object TestData extends LazyLogging {

  private lazy val files: Seq[File] = FileUtils
    .listFiles(new File("src/test/resources/testdata"), Array("txt"), false)
    .asScala
    .toList

  lazy val loadedFiles: Map[String, String] =
    files.map { file =>
      val source = Source.fromFile(file.getCanonicalPath)
      val data   = source.mkString
      source.close()
      file.getName.replace(".txt", "") -> data
    }.toMap
}
