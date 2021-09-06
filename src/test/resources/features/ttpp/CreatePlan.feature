@ignore



Feature: Create Plan

  Scenario: Retrieve create plan response from Time to Pay Proxy
    Given a create plan request
      | customerReference | planId     | paymentMethod | paymentReference | thirdPartyBank | numberOfInstalments | totalDebtAmount | totalInterest |
      | customerRef1234   | planId1234 | BACS          | paymentRef1234   | false          | 2                   | 1000            | 0.26          |

    And instalments are
      | dutyId | debtId | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber |
      | duty01 | debt01 | 2021-05-01 | 100       | 100             | 0.26         | 1                |
      | duty01 | debt01 | 2021-05-01 | 100       | 100             | 0.26         | 2                |

    When the create plan request is sent to the ttpp service

    Then the ttp service is going to return a create plan response with
      | customerReference | planId     | planStatus |
      | customerRef1234   | planId1234 | xyz        |


  Scenario: Retrieve create plan response from Time to Pay Proxy
    Given a create plan request
      | customerReference | quoteReference | channelIdentifier | paymentMethod | paymentReference | thirdPartyBank | numberOfInstalments | totalDebtAmount | totalInterest |
      | uniqRef1234       | quoteRef1234   | channelIdentifier | BACS          | paymentRef1234   | false          | 2                   | 1000            | 0.26          |

    And instalments are
      | dutyId | debtId | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber |
      | duty01 | debt01 | 2021-05-01 | 100       | 100             | 0.26         | 1                |
      | duty01 | debt01 | 2021-05-01 | 100       | 100             | 0.26         | 2                |

    When the create plan request is sent to the ttpp service

    Then the ttp service is going to return a create plan response with
      | customerReference | planId     | planStatus |
      | customerRef1234   | planId1234 | success    |

  @wip2
  Scenario: create plan
    Given a create plan
      | customerReference | quoteReference | channelIdentifier |
      | uniqRef1234       | quoteRef1234   | channelIdentifier |
    And create payment plan details
      | quoteId | quoteType        | quoteDate  | instalmentStartDate | paymentPlanType | thirdPartyBank | numberOfInstalments | frequency | duration | initialPaymentAmount | totalDebtincInt | totalInterest | interestAccrued | planInterest |
      | quoteId | instalmentAmount | 2021-05-13 | 2021-05-13          | timeToPay       | true           | 1                   | annually  | 12       | 100                  | 10              | 0.14          | 10              | 0.24         |
    And customer address details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And debt payment method details
      | paymentMethod | paymentReference |
      | BACS          | paymentRef123    |
    And the debt item has payment history
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    And the debt item has payment history
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |

    And debt instalments repayment details
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.26         | 1                | 0.25                      | 100               |
    When the create plan request is sent to the ttpp service

    Then the ttp service is going to return a create plan response with
      | customerReference | planId     | caseId | planStatus |
      | customerRef1234   | planId1234 | caseId | success    |