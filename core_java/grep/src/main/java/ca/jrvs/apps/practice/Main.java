package ca.jrvs.apps.practice;

import java.util.function.Consumer;

public class Main {
//  public static void main(String[] args) {
//    RegexExc regex = new RegexExcImp();
//
//    System.out.println(regex.matchJpeg("photo.JPG"));
//    System.out.println(regex.matchJpeg("photo.JPGG"));
//    System.out.println(regex.matchIp("192.168.1.1"));
//    System.out.println(regex.isEmptyLine("     "));
//    System.out.println(regex.isEmptyLine("hello"));
//    System.out.println(regex.matchIp("999.999.999.999"));
//    System.out.println(regex.matchJpeg("pic.png"));
//  }

  public static void main(String[] args) {
    LambdaStreamExc lse = new LambdaStreamImp();;

    // Test toUpperCase
    lse.toUpperCase("hello", "world").forEach(System.out::println);

    // Test printMessages
    String[] messages = {"a", "b", "c"};
    Consumer<String> printer = lse.getLambdaPrinter("msg:", "!");
    lse.printMessages(messages, printer);

    // Test printOdd
    lse.printOdd(lse.createIntStream(0, 5), lse.getLambdaPrinter("odd:", "!"));
  }
}
