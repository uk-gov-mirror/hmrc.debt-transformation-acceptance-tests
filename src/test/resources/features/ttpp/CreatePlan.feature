@createPlan
Feature: TTP Create Plan Request

  Scenario: TTP Promote an Arrangement request to create a plan for storage
    Given a valid create plan request
    When the create plan request is sent to the ttpp service

    Then the ttp service is going to return a create plan response with
      | customerReference | planId     | caseId | planStatus |
      | customerRef1234   | planId1234 | caseId | success    |

  Scenario: TTP Promote an Arrangement request to create a plan for storage -empty customerReference
    Given a create plan request with an empty customer reference
    When the create plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Could not parse body due to requirement failed: customerReference should not be empty"}


  Scenario: TTP Promote an Arrangement request to create a plan for storage -empty quoteReference
    Given a create plan request with an empty quote reference
    When the create plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Could not parse body due to requirement failed: quoteReference should not be empty"}


  Scenario: TTP Promote an Arrangement request to create a plan for storage -empty channelIdentifier
    Given a create plan request with an empty channel identifier
    When the create plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Invalid CreatePlanRequest payload: Payload has a missing field or an invalid format. Field name: channelIdentifier. Valid enum value should be provided"}


  Scenario: TTP Promote an Arrangement request to create a plan for storage -empty quoteId
    Given a create plan request with an empty quote id
    When the create plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Could not parse body due to requirement failed: quoteId should not be empty"}


  Scenario: TTP Promote an Arrangement request to create a plan for storage -empty quoteType
    Given a create plan request with an empty quote type
    When the create plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Invalid CreatePlanRequest payload: Payload has a missing field or an invalid format. Field name: quoteType. Valid enum value should be provided"}


  Scenario: TTP Promote an Arrangement request to create a plan for storage -empty quoteDate
    Given a create plan request with an empty quote date
    When the create plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Invalid CreatePlanRequest payload: Payload has a missing field or an invalid format. Field name: quoteDate. Date format should be correctly provided"}


