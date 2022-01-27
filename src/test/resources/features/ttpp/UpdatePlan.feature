@updatePlan
Feature: TTP Update Plan Request

  Scenario: Update Existing TTP Plan
    Given an update plan request
      | customerReference | planId     | updateType | planStatus           | completeReason | cancellationReason | thirdPartyBank | paymentMethod | paymentReference |
      | customerRef1234   | planId1234 | planStatus | Resolved - Completed | earlyRepayment | some reason        | true           | BACS          | paymentRef123    |
    When the update plan request is sent to the ttpp service
    Then the ttp service is going to return an update response with
      | customerReference | planId     | planStatus           | quoteUpdatedDate |
      | custRef1234       | planId1234 | Resolved - Completed | 2021-05-13       |


  Scenario: Cancel existing TTP plan
    Given an update plan request
      | customerReference | planId      | updateType | planStatus           | completeReason | cancellationReason | thirdPartyBank | paymentMethod | paymentReference |
      | customerRef12345  | planId12345 | planStatus | Resolved - Cancelled | earlyRepayment | some reason        | true           | BACS          | paymentRef123    |
    When the update plan request is sent to the ttpp service
    Then the ttp service is going to return an update response with
      | customerReference | planId      | planStatus           | quoteUpdatedDate |
      | custRef12345      | planId12345 | Resolved - Cancelled | 2021-05-13       |


  Scenario: Update plan - no payment reference
    Given an update plan request
      | customerReference | planId     | updateType     | thirdPartyBank | paymentMethod | paymentReference |
      | customerRef1234   | planId1234 | paymentDetails | true           | BACS          |                  |
    When the update plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Could not parse body due to requirement failed: paymentReference should not be empty"}


  Scenario: Update plan - Direct Debit should always have payment reference
    Given an update plan request
      | customerReference | planId     | updateType     | thirdPartyBank | paymentMethod |
      | customerRef1234   | planId1234 | paymentDetails | true           | directDebit   |
    When the update plan request is sent to the ttpp service
    Then service returns response code 400
    And service returns error message {"statusCode":400,"errorMessage":"Could not parse body due to requirement failed: Direct Debit should always have payment reference"}

