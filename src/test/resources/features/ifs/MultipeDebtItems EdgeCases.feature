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
#9. debts, 5 payments on 1 debt
Feature: Multiple Debt Items - Edge Cases

  Scenario: 5. 2 debts, 1 interest bearing. 1 non interest bearing
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1520      | 1090     | false           |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 28                   | 3739                 | 900000            | 903739              | 900000              |
    And the 1st debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 168          | 28                      | 3739                 | 400000           | 403739             | 400000               | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-03 | 49           | 2.6          | 7                       | 349               | 100000               | 100349             |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 28                      | 3390              | 400000               | 403390             |
    And the 2nd debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 0            | 0                       | 0                    | 500000           | 500000             | 500000               | 500000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 0            | 0.0          | 0                       | 0                 | 500000               | 500000             |

  Scenario: 6. 2 debts, 1 payment each of different amounts
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1520      | 1090     | false           |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 28                   | 3739                 | 800000            | 803739              | 800000              |
    And the 1st debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 168          | 28                      | 3739                 | 400000           | 403739             | 400000               | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-03 | 49           | 2.6          | 7                       | 349               | 100000               | 100349             |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 28                      | 3390              | 400000               | 403390             |
    And the 2nd debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 0            | 0                       | 0                    | 400000           | 400000             | 400000               | 400000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-03 | 0            | 0.0          | 0                       | 0                 | 100000               | 100000             |
      | 2020-12-16 | 2021-04-14 | 0            | 0.0          | 0                       | 0                 | 400000               | 400000             |

  Scenario: 7. 3 debts, 1 payments
    And a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has no payment history
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 98                   | 12215                | 1400000           | 1412215             | 1400000             |
    And the 1st debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 119          | 35                      | 4238                 | 500000           | 504238             | 500000               | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 35                      | 4238              | 500000               | 504238             |
    And the 2nd debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 168          | 28                      | 3739                 | 400000           | 403739             | 400000               | 400000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-03 | 49           | 2.6          | 7                       | 349               | 100000               | 100349             |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 28                      | 3390              | 400000               | 403390             |
    And the 3rd debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 119          | 35                      | 4238                 | 500000           | 504238             | 500000               | 500000             |
    And the 3rd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 35                      | 4238              | 500000               | 504238             |

#    300 debts items is the max says Helen
 Scenario: 8. 300 debt items
    Given 300 debt items
    When the debt items is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 10500                | 1271400              | 150000000         | 151271400           | 150000000           |
    And the 300th debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 119          | 35                      | 4238                 | 500000           | 504238             | 500000             |

  Scenario: 9. 2 debts, 5 payments on 1 debt
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 1000000        | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
      | 200000     | 2021-02-03    |
      | 100000     | 2021-02-13    |
      | 100000     | 2021-02-06    |
      | 100000     | 2021-02-13    |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 63                   | 9885                 | 900000            | 909885              | 900000              |
    And the 1st debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 279          | 28                      | 5647                 | 400000           | 405647             | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-13 | 59           | 2.6          | 14                      | 840               | 200000               | 200840             |
      | 2020-12-16 | 2021-02-06 | 52           | 2.6          | 7                       | 370               | 100000               | 100370             |
      | 2020-12-16 | 2021-02-03 | 49           | 2.6          | 21                      | 1047              | 300000               | 301047             |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 28                      | 3390              | 400000               | 403390             |
    And the 2nd debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 119          | 35                      | 4238                 | 500000           | 504238             | 500000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 35                      | 4238              | 500000               | 504238             |