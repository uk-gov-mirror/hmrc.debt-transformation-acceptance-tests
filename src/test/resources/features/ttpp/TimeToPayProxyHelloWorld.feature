
Feature: Time To Pay Proxy Hello World test

  Scenario: Retrieve hello world response from Time to Pay Proxy
    When a request is made to get response from ttpp hello world endpoint
    Then the ttpp response code should be 200
    And the ttpp hello world response body should be Hello world

  Scenario: Unable to retrieve hello world response from Time to Pay Proxy
    When a request is made to an invalid ttpp endpoint
    Then the ttpp response code should be 404
