package profileFeature;

import com.intuit.karate.junit5.Karate;

public final class TestRunner {
	@Karate.Test
	Karate heartbeat() {
		return Karate.run("heartbeat").relativeTo(getClass());
	}
	@Karate.Test
	Karate AdminCache() {
		return Karate.run("adminCache").relativeTo(getClass());
	}
	@Karate.Test
	Karate Profiles() {
		return Karate.run("profiles").relativeTo(getClass());
	}
}
