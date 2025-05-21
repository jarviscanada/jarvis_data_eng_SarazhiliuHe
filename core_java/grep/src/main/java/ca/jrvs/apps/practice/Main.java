package ca.jrvs.apps.practice;

public class Main {
  public static void main(String[] args) {
    RegexExc regex = new RegexExcImp();

    System.out.println(regex.matchJpeg("photo.JPG"));
    System.out.println(regex.matchJpeg("photo.JPGG"));
    System.out.println(regex.matchIp("192.168.1.1"));
    System.out.println(regex.isEmptyLine("     "));
    System.out.println(regex.isEmptyLine("hello"));
    System.out.println(regex.matchIp("999.999.999.999"));
    System.out.println(regex.matchJpeg("pic.png"));
  }
}
