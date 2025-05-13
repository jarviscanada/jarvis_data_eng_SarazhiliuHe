package ca.jrvs.apps.practice;

import java.util.regex.Pattern;

public class RegexExcImp implements RegexExc {

  @Override
  public boolean matchJpeg(String filename) {
    return Pattern.compile("(?i).+\\.(jpg|jpeg)$").matcher(filename).matches();
  }

  @Override
  public boolean matchIp(String ip) {
    return Pattern.compile("^(\\d{1,3}\\.){3}\\d{1,3}$").matcher(ip).matches();
  }

  @Override
  public boolean isEmptyLine(String line) {
    return Pattern.compile("^\\s*$").matcher(line).matches();
  }
}

