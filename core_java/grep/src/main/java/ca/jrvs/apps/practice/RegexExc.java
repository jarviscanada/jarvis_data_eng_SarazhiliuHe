package ca.jrvs.apps.practice;

/**
 * An interface for regex-based string validation.
 */
public interface RegexExc {

  boolean matchJpeg(String filename);

  boolean matchIp(String ip);

  boolean isEmptyLine(String line);
}
