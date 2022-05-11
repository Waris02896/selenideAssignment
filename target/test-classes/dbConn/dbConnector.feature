Feature: Db Connection

  Background:
    * def config = { username: 'sa', password: '', url: 'jdbc:h2:mem:testdb', driverClassName: 'org.h2.Driver' }
    * def DbUtils = Java.type('DbUtils')
    * def db = new DbUtils(config)

    @ignore
  Scenario: Connect Desire Database
      * def testDatafromDB = db.readRow('select * from table')
      Then print 'Result from Database --> ', testDatafromDB
