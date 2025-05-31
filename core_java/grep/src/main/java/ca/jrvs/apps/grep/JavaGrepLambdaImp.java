package ca.jrvs.apps.grep;

import org.apache.log4j.BasicConfigurator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.regex.Pattern;
import java.util.stream.Stream;
import java.util.List;
import java.util.stream.Collectors;

public class JavaGrepLambdaImp implements JavaGrepLambda {

  final Logger logger = LoggerFactory.getLogger(JavaGrepLambdaImp.class);

  private String regex;
  private String rootPath;
  private String outFile;
  private Pattern pattern;

  @Override
  public void process() throws IOException {
    pattern = Pattern.compile(regex);

    try (Stream<File> fileStream = listFilesStream(rootPath)) {
      List<String> matchedLines = fileStream
          .flatMap(this::readLinesStream)  // read lines as stream
          .filter(this::containsPattern)   // filter matching lines
          .collect(Collectors.toList());   // collect to list

      writeToFile(matchedLines);
    }
  }

  @Override
  public Stream<File> listFilesStream(String rootDir) {
    File root = new File(rootDir);
    if (!root.isDirectory()) {
      return Stream.empty();
    }

    File[] files = root.listFiles();
    if (files == null) {
      return Stream.empty();
    }

    return Stream.of(files)
        .flatMap(file -> file.isDirectory() ? listFilesStream(file.getAbsolutePath()) : Stream.of(file));
  }

  @Override
  public Stream<String> readLinesStream(File inputFile) {
    if (!inputFile.isFile()) {
      throw new IllegalArgumentException("Not a file: " + inputFile.getAbsolutePath());
    }

    try {
      return new BufferedReader(new FileReader(inputFile)).lines();
    } catch (IOException e) {
      logger.error("Error: Failed to read file: " + inputFile.getAbsolutePath(), e);
      return Stream.empty();
    }
  }

  @Override
  public boolean containsPattern(String line) {
    return pattern.matcher(line).find();
  }

  @Override
  public void writeToFile(List<String> lines) throws IOException {
    try (BufferedWriter writer = new BufferedWriter(new FileWriter(outFile))) {
      for (String line : lines) {
        writer.write(line);
        writer.newLine();
      }
    } catch (IOException e) {
      logger.error("Error: Failed to write to output file", e);
    }
  }

  // Inherited from JavaGrep
  @Override
  public String getRootPath() { return rootPath; }
  @Override
  public void setRootPath(String rootPath) { this.rootPath = rootPath; }
  @Override
  public String getRegex() { return regex; }
  @Override
  public void setRegex(String regex) { this.regex = regex; }
  @Override
  public String getOutFile() { return outFile; }
  @Override
  public void setOutFile(String outFile) { this.outFile = outFile; }

  public static void main(String[] args) {
    if (args.length != 3) {
      throw new IllegalArgumentException("USAGE: JavaGrep regex rootPath outFile");
    }

    BasicConfigurator.configure();

    JavaGrepLambdaImp javaGrep = new JavaGrepLambdaImp();
    javaGrep.setRegex(args[0]);
    javaGrep.setRootPath(args[1]);
    javaGrep.setOutFile(args[2]);

    try {
      javaGrep.process();
    } catch (Exception e) {
      javaGrep.logger.error("Error: Unable to process", e);
    }
  }

  // Old listFiles and readLines fallback
  @Override
  public List<File> listFiles(String rootDir) {
    return listFilesStream(rootDir).collect(Collectors.toList());
  }

  @Override
  public List<String> readLines(File inputFile) {
    return readLinesStream(inputFile).collect(Collectors.toList());
  }
}
