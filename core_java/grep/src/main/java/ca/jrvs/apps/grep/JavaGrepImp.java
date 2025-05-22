package ca.jrvs.apps.grep;

import org.apache.log4j.BasicConfigurator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class JavaGrepImp implements JavaGrep {

  final Logger logger = LoggerFactory.getLogger(JavaGrepImp.class);

  private String regex;
  private String rootPath;
  private String outFile;
  private Pattern pattern;

  @Override
  public String getRegex() {
    return regex;
  }

  @Override
  public void setRegex(String regex) {
    this.regex = regex;
  }

  @Override
  public String getRootPath() {
    return rootPath;
  }

  @Override
  public void setRootPath(String rootPath) {
    this.rootPath = rootPath;
  }

  @Override
  public String getOutFile() {
    return outFile;
  }

  @Override
  public void setOutFile(String outFile) {
    this.outFile = outFile;
  }

  public static void main(String[] args) {
    if (args.length != 3) {
      throw new IllegalArgumentException("USAGE: JavaGrep regex rootPath outFile");
    }
    BasicConfigurator.configure();

    JavaGrepImp javaGrepImp = new JavaGrepImp();
    javaGrepImp.setRegex(args[0]);
    javaGrepImp.setRootPath(args[1]);
    javaGrepImp.setOutFile(args[2]);

    try {
      javaGrepImp.process();
    } catch (Exception ex) {
      javaGrepImp.logger.error("Error: Unable to process", ex);
    }
  }

  @Override
  public void process() throws IOException {
    pattern = Pattern.compile(regex);
    List<File> files = listFiles(rootPath);
    List<String> matchedLines = new ArrayList<>();

    for (File file : files) {
      for (String line : readLines(file)) {
        if (containsPattern(line)) {
          matchedLines.add(line);
        }
      }
    }

    writeToFile(matchedLines);
  }

  @Override
  public List<File> listFiles(String rootDir) {
    List<File> result = new ArrayList<>();
    File root = new File(rootDir);
    File[] files = root.listFiles();

    if (files != null) {
      for (File file : files) {
        if (file.isDirectory()) {
          result.addAll(listFiles(file.getAbsolutePath()));
        } else {
          result.add(file);
        }
      }
    }

    return result;
  }

  @Override
  public List<String> readLines(File inputFile) {
    if (!inputFile.isFile()) {
      throw new IllegalArgumentException("Not a valid file: " + inputFile.getAbsolutePath());
    }

    List<String> lines = new ArrayList<>();

    try (BufferedReader reader = new BufferedReader(new FileReader(inputFile))) {
      String line;
      while ((line = reader.readLine()) != null) {
        lines.add(line);
      }
    } catch (IOException e) {
      logger.error("Error: Failed to read file: " + inputFile.getAbsolutePath(), e);
    }

    return lines;
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
}
