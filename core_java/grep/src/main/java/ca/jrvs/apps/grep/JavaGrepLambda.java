package ca.jrvs.apps.grep;

import java.io.File;
import java.util.stream.Stream;

public interface JavaGrepLambda extends JavaGrep {

  /**
   * Traverse a directory and return a Stream of files
   * @param rootDir input directory
   * @return stream of files
   */
  Stream<File> listFilesStream(String rootDir);

  /**
   * Read a file and return a Stream of lines
   * @param inputFile file to read
   * @return stream of lines
   */
  Stream<String> readLinesStream(File inputFile);
}
