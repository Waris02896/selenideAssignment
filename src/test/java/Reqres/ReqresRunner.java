package Reqres;

import com.intuit.karate.junit5.Karate;

public class ReqresRunner {
    @Karate.Test
    Karate reqRes() {
        return Karate.run("Reqres.feature").relativeTo(getClass());
    }

    @Karate.Test
    Karate reqResQuestionTwo() {
        return Karate.run("Reqres.feature").tags("Question2").relativeTo(getClass());
    }

    @Karate.Test
    Karate reqResQuestionThree() {
        return Karate.run("Reqres.feature").tags("Question3").relativeTo(getClass());
    }

    @Karate.Test
    Karate reqResQuestionFour() {
        return Karate.run("Reqres.feature").tags("Question4").relativeTo(getClass());
    }
}
