Feature: TTP View Plan Request

  Scenario: Retrieve existing plan from Time to Pay Proxy
    Given a view plan request
      | customerReference | planId     |
      | customerRef1234   | planId1234 |

    When the view plan request is sent to the ttpp service

    Then the ttp service is going to return a view response with
      | customerReference | planId     | quoteType | paymentMethod | paymentReference | numberOfInstalments | totalDebtAmount | totalInterest |
      | customerRef1234   | planId1234 | duration  | BACS          | paymentRef1234   | 2                   | 500             | 4.9           |

    And the 1st view response instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 10              | 2.5         | 1                | 0.25                      | 100               |
    And the 2nd view response instalment will contain
      | dutyId | debtId | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | duty01 | debt01 | 2021-08-30 | 400       | 200             | 2.4          | 2                | 2.5                       | 200               |
