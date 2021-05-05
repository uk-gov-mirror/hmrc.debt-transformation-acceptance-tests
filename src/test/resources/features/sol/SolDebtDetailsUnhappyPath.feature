Feature: Statement of liability Unhappy Path (Service Errors)

  Scenario: Sol Pega Debt Case Management Failure - invalid debt ID
    Given debt details
      | solType | debtId  | mainTrans | subTrans |
      | UI      | debt003 | 1525      | 1000     |
    And add debt item chargeIDs to the debt
      | dutyId   |
      | "duty01" |
      | "duty02" |
    When a debt statement of liability is requested
    Then the sol response code should be 404
    And the sol service will respond with {name: DebtCaseManagementError, statusCode: 404, uniqueReference: debt003}
    
  Scenario: Sol Reference data service failure - invalid main trans
    Given debt details
      | solType | debtId  | mainTrans | subTrans |
      | UI      | debt002 | 1525      | 1000     |
    And add debt item chargeIDs to the debt
      | dutyId   |
      | "duty01" |
      | "duty02" |
      | "duty03" |
    When a debt statement of liability is requested
    Then the sol response code should be 404
    And the sol service will respond with {name: ReferenceDataLookupError, statusCode: 404, uniqueReference: 1085, 1000}

