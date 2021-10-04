@updatePlan
Feature: TTP Update Plan Request

  Scenario: Update Existing TTP Plan
    Given an update plan request
      | customerReference | planId     | updateType | planStatus | completeReason | cancellationReason | thirdPartyBank | paymentMethod | paymentReference |
      | customerRef1234   | planId1234 | updateType | success    | earlyRepayment | some reason        | true           | BACS          | paymentRef123    |

    When the update plan request is sent to the ttpp service

    Then the ttp service is going to return an update response with
      | customerReference | planId     | quoteStatus | quoteUpdatedDate |
      | custRef1234   | planId1234 | complete    | 2021-05-13       |
