# Grep App

## Introduction

This is a Java-based application that mimics basic functionality of the Unix `grep` command using Java Regex API.
It searches for lines matching a regular expression in a directory of text files. 
The app supports local execution, `.jar` deployment, and Docker container usage.

It uses core Java, Java 8 Lambda and Stream APIs for efficient data processing. The project is built and managed with Maven and is dockerized for easier distribution and deployment. 

## Quick Start
1. Run directly and add arguments in configuration:
   ```bash
   mvn clean package
   ```

2. Run with fat jar:

   ```bash
   java -jar target/grep-1.0-SNAPSHOT.jar ".*Romeo.*Juliet.*" ./data ./out/grep.txt
   ```
3. Run in Docker:

   ```bash
   docker run --rm \
     -v $(pwd)/data:/data \
     -v $(pwd)/log:/log \
     your_docker_id/grep ".*Romeo.*Juliet.*" /data /log/grep.out
   ```

## Implementation

### Pseudocode for `process` method

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
