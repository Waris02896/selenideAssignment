package controllerFeature;

import com.intuit.karate.junit5.Karate;

public final class HeartBeatRunner {
    @Karate.Test
    Karate heartbeat() {
        return Karate.run("heartbeat").relativeTo(getClass());
    }
}
