package ca.jrvs.apps.grep;

import org.junit.Test;
import static org.junit.Assert.*;
import java.io.File;

public class JavaGrepLambdaImpTest {

  @Test
  public void testEndToEndProcess() {
    JavaGrepLambdaImp grep = new JavaGrepLambdaImp();
    grep.setRegex("Romeo");
    grep.setRootPath("data/txt");
    grep.setOutFile("out/test_output.txt");

    try {
      grep.process();

      File outputFile = new File("out/test_output.txt");
      assertTrue(outputFile.exists());
      assertTrue(outputFile.length() > 0); // Should have some matched lines

    } catch (Exception e) {
      fail("Process failed: " + e.getMessage());
    }
  }
}
