package dbConn;

import com.intuit.karate.junit5.Karate;

public final class DbTestRunner {
	@Karate.Test
	Karate dbConnector() {
		return Karate.run("dbConnector").relativeTo(getClass());
	}
}