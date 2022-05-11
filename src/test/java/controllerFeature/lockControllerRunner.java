package controllerFeature;


import com.intuit.karate.junit5.Karate;

public final class lockControllerRunner {
    @Karate.Test
    Karate LockController() {
        return Karate.run("LockController").relativeTo(getClass());
    }
}
