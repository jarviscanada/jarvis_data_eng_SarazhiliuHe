package ca.jrvs.apps.practice;

public class Main {
  public static void main(String[] args) {
    RegexExc regex = new RegexExcImp();

    System.out.println(regex.matchJpeg("photo.JPG"));        // true
    System.out.println(regex.matchIp("192.168.1.1"));        // true
    System.out.println(regex.isEmptyLine("     "));          // true
    System.out.println(regex.matchIp("999.999.999.999"));    // true (allowed by spec)
    System.out.println(regex.matchJpeg("pic.png"));          // false
  }
}
