package RestfulBooker;

import com.intuit.karate.junit5.Karate;

public class RestFulBookerRunner {
    @Karate.Test
    Karate LockController() {
        return Karate.run("RestFulBooker.feature").relativeTo(getClass());
    }
}
