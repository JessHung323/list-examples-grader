import static org.junit.Assert.*;
import org.junit.*;
import java.util.Arrays;
import java.util.List;

class IsMoon implements StringChecker {
  public boolean checkString(String s) {
    return s.equalsIgnoreCase("moon");
  }
}

public class TestListExamples {
  @Test(timeout = 500)
  public void testMergeRightEnd() {
    List<String> left = Arrays.asList("a", "b", "c");
    List<String> right = Arrays.asList("a", "d");
    List<String> merged = ListExamples.merge(left, right);
    List<String> expected = Arrays.asList("a", "a", "b", "c", "d");
    assertEquals(expected, merged);
  }

  @Test(timeout = 500)
  public void testFilter() {
    List<String> input = Arrays.asList("a", "b", "Moon");
    StringChecker checker = new IsMoon();
    List<String> actual = ListExamples.filter(input, checker);
    List<String> expected = Arrays.asList("Moon");
    assertEquals(expected, actual);
  }

  @Test(timeout = 500)
  public void testFilter2() {
    List<String> input = Arrays.asList("mOon", "moo n", "Moon");
    StringChecker checker = new IsMoon();
    List<String> actual = ListExamples.filter(input, checker);
    List<String> expected = Arrays.asList("mOon", "Moon");
    assertEquals(expected, actual);
  }
}
