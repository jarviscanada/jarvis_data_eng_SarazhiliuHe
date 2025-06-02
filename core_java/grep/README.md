# Grep App

## Introduction
Grep App is a Java application that mimics the Linux `grep` command which allows user to search for lines matching a regular expression in a directory of text files.
It uses Java, Lambda and Stream APIs for efficient data processing. The project is built and managed with Maven and is dockerized for easier distribution and deployment.

## Quick Start
1. USAGE: regex rootPath outFile
   - regex: a special text string for describing a search pattern
   - rootPath: root directory path
   - outFile: output file name

2. Linux `grep` command
     ```bash
     regex_pattern=".*Romeo.*Juliet.*"
     src_dir="./data"
     grep -eR ${regex_pattern} ${src_dir}
     ```

3. Run the jar file:

   ```bash
   java -jar target/grep-1.0-SNAPSHOT.jar ".*Romeo.*Juliet.*" ./data ./out/grep.txt
   ```
4. Run in Docker:

   ```bash
   docker run --rm \
     -v $(pwd)/data:/data \
     -v $(pwd)/log:/log \
     your_docker_id/grep ".*Romeo.*Juliet.*" /data /log/grep.out
   ```

## Implementation

The core logic uses:
- **Streams** for lazy, efficient processing of directories and files.
- **BufferedReader.lines()** to avoid loading entire files into memory.
- **SLF4J/Log4j** for logging errors and status messages.
- **Try-with-resources** for safe resource management (files and streams).

### Methods

- `process()` orchestrates the entire search workflow.
   ```
   process() {
     compile regex pattern
     open output writer
     list all files recursively as a stream
     for each file:
       open file as a stream of lines
       filter lines that match the regex
       write each matching line directly to output
   }
   ```
- `listFilesStream(String rootDir)`
Returns a stream of all files under the given directory (including subdirectories).

- `readLinesStream(File inputFile)`
Opens the file as a stream of lines (BufferedReader.lines()).
Handles exceptions and logs errors.

- `containsPattern(String line)`
Returns true if the line matches the compiled regex pattern.

- `writeToFile(List<String> lines)`
Writes the given list of strings to the specified output file.
Uses BufferedWriter for efficient writing.

- `listFiles(String rootDir)`
Fallback method (required by the JavaGrep interface).
Collects all file paths into a List<File> using the stream-based listFilesStream.

- `readLines(File inputFile)`
Fallback method (required by the JavaGrep interface).
Collects all lines into a List<String> using the stream-based readLinesStream.

- `get/setRegex, get/setRootPath, get/setOutFile`
Standard getters and setters for regex, rootPath, and outFile.

- `main(String[] args)`
Entry point for the app.
Validates arguments, configures logging, and starts the process.

### Performance Issue

When working with large files (e.g., 50GB), 
storing all lines in memory (`List<String>`) causes `OutOfMemoryError`. 
We fixed this by using the `Stream` API and `BufferedReader` to process lines one by one, significantly reducing memory usage.

## Test

We manually prepared sample data files and tested the app by running it with various regex patterns. 
We then compared the output files to the expected results to verify correctness.

## Deployment

We created a `Dockerfile` using the lightweight OpenJDK 8 Alpine image and 
copied the fat JAR file into the image. 
Using `docker build`, we built a Docker image, and then pushed it to Docker Hub. 
Users can now easily pull and run the container without worrying about Java or dependencies.

## Improvement

1. Add automated unit tests (JUnit) to cover all core functionalities.
2. Support parallel file processing to speed up search on multi-core CPUs.
3. Improve error handling and logging to better debug and maintain the app.
