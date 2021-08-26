Feature: Statement of liability Unhappy Path (Service Errors)

  Scenario: Send error message where no debt items are provided when SoL is called - DTD-545
    Given a request to sol with no debt items provided
    When a debt statement of liability is requested
    Then the sol response code should be 400
    And the sol service will respond with {"reason":"Could not parse body due to requirement failed: Debts which are mandatory, are missing","message":"Invalid Json"}

  Scenario: Sol Pega Debt Case Management Failure - invalid debt ID
    Given debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo | solRequestedDate |
      | UI      | debt999 | 1525      | 1000     | 2021-08-10          | 2021-05-13       |

    And add debt item chargeIDs to the debt
      | dutyId |
      | duty01 |
      | duty02 |
    When a debt statement of liability is requested
    Then the sol response code should be 404
    And the sol service will respond with {"statusCode":404,"reason":"DebtCaseManagementError","message":"The service returned with an 404 for the following identifier: debt999"}

  Scenario: Sol Reference data service failure - invalid main trans
    Given debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo | solRequestedDate |
      | UI      | debt007 | 1525      | 1000     | 2021-08-10          | 2021-05-13       |
    And add debt item chargeIDs to the debt
      | dutyId |
      | duty01 |
      | duty02 |
      | duty03 |
    When a debt statement of liability is requested
    Then the sol response code should be 404
    And the sol service will respond with {"statusCode":404,"reason":"ReferenceDataLookupError","message":"The service returned with an 404 for the following identifier: [{\"mainTrans\":\"1085\",\"subTrans\":\"1000\"}]"}
