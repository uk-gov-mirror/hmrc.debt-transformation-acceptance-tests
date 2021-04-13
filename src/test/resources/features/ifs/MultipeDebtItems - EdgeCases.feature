#  Assumptions
#  Initial amount and date
#  REGIME == DRIERd
#  NO suppression period
#  NO breathing space
#  Date Amount  == Interest start date


# DTD-171. Multiple Debt Items Edge cases
#5. 2 debts, 1 interest bearing. 1 non interest bearing
#6. 2 debts, 1 payment each of different amounts
#7. 3 debts, 2 payments
#8. 300 debt items

  Scenario: 5. 2 debts, 1 interest bearing. 1 non interest bearing
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | HIPG       | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 10            | 1449          | 900000           | 901449                  | 900000                        |
    And the 1st debt summary will contain
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 10            | 1449          | 400000           | 401449                  | 400000                        |
    And the 1st debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest | totalAmountOnWhichInterestDue |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        |
    And the 2nd debt summary will contain
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 0             | 0             | 500000           | 500000                  | 500000                        |
    And the 2nd debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest | totalAmountOnWhichInterestDue |
      | 2020-12-16 | 2021-04-14 | 0          | 0       | 0             | 0             | 500000                        |

  Scenario: 6. 2 debts, 1 payment each of different amounts
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | HIPG       | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 10            | 1449          | 800000           | 801449                  | 800000                        |
    And the 1st debt summary will contain
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 10            | 1449          | 400000           | 401449                  | 400000                        |
    And the 1st debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest | totalAmountOnWhichInterestDue |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        |
    And the 2nd debt summary will contain
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 0             | 0             | 400000           | 400000                  | 400000                        |
    And the 2nd debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest | totalAmountOnWhichInterestDue |
      | 2020-12-16 | 2021-02-02 | 0          | 0       | 0             | 0             | 500000                        |
      | 2021-02-03 | 2021-04-14 | 0          | 0       | 0             | 0             | 400000                        |

  Scenario: 7. 3 debts, 2 payments
    And a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has no payment history
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 36            | 4735          | 1400000          | 1404735                 | 1400000                       |
    And the 1st debt summary will contain
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 13            | 1643          | 500000           | 501643                  | 500000                        |
    And the 1st debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest | totalAmountOnWhichInterestDue |
      | 2020-12-16 | 2021-04-14 | 120        | 1       | 13            | 1643          | 500000                        |
    And the 2nd debt summary will contain
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 10            | 1449          | 400000           | 401449                  | 400000                        |
    And the 2nd debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest | totalAmountOnWhichInterestDue |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        |
    And the 3rd debt summary will contain
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 13            | 1643          | 500000           | 501643                  | 500000                        |
    And the 3rd debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest | totalAmountOnWhichInterestDue |
      | 2020-12-16 | 2021-04-14 | 120        | 1       | 13            | 1643          | 500000                        |

  Scenario: 8. 300 debt items
    Given 300 debt items
    When the debt items is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | dailyInterest | totalInterest | totalAmountToPay | totalAmountWithInterest | totalAmountOnWhichInterestDue |
      | 3900          | 492900        | 150000000        | 150492900               | 150000000                     |
