package demo;

import com.intuit.karate.junit5.Karate;

public final class TestRunner {
	@Karate.Test
	Karate PostRequest() {
		return Karate.run("PostRequest").relativeTo(getClass());
	}
	@Karate.Test
	Karate PutRequest() {
		return Karate.run("PutRequest").relativeTo(getClass());
	}
	@Karate.Test
	Karate GetRequest() {
		return Karate.run("GetRequest").relativeTo(getClass());
	}
	@Karate.Test
	Karate GetRequest_ContractA() {
		return Karate.run("GetRequest_ContractA").relativeTo(getClass());
	}
	@Karate.Test
	Karate GetRequest_ContractB() {
		return Karate.run("GetRequest_ContractB").relativeTo(getClass());
	}
	@Karate.Test
	Karate PostRequest_DataDriven() {
		return Karate.run("PostRequest_DataDriven").relativeTo(getClass());
	}
}