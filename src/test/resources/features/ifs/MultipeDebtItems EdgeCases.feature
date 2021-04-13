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
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1520  | 1000       | false            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 10            | 1449          | 900000           | 901449                  | 900000                        |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 10            | 1449          | 400000           | 401449                  | 400000                        | 400000                |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        | 500000                             |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        | 400000                             |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 0             | 0             | 500000           | 500000                  | 500000                        | 500000                |
    And the 2nd debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 0          | 0       | 0             | 0             | 500000                        | 500000                             |

  Scenario: 6. 2 debts, 1 payment each of different amounts
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1520  | 1000       | false            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 10            | 1449          | 800000           | 801449                  | 800000                        |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 10            | 1449          | 400000           | 401449                  | 400000                        | 400000                |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        | 500000                             |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        | 400000                             |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 0             | 0             | 400000           | 400000                  | 400000                        | 400000                |
    And the 2nd debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 0          | 0       | 0             | 0             | 500000                        | 500000                             |
      | 2021-02-03 | 2021-04-14 | 0          | 0       | 0             | 0             | 400000                        | 400000                             |

  Scenario: 7. 3 debts, 2 payments
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has no payment history
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 36            | 4735          | 1400000          | 1404735                 | 1400000                       |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 13            | 1643          | 500000           | 501643                  | 500000                        | 500000                |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 120        | 1       | 13            | 1643          | 500000                        | 500000                             |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 10            | 1449          | 400000           | 401449                  | 400000                        | 400000                |
    And the 2nd debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        | 500000                             |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        | 400000                             |
    And the 3rd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 13            | 1643          | 500000           | 501643                  | 500000                        | 500000                |
    And the 3rd debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 120        | 1       | 13            | 1643          | 500000                        | 500000                             |

#    300 debts items is the max says Helen
  Scenario: 8. 300 debt items
    Given 300 debt items
    When the debt items is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 3900          | 492900        | 150000000        | 150492900               | 150000000                     |
    And the 300th debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 13            | 1643          | 500000           | 501643                  | 500000                        |

#    Current implementation. 2 of the windows have toDates before fromDates. Helen confirming 13/4
  Scenario: 9. 2 debts, 5 payments on 1 debt
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 1000000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
      | 200000     | 2021-02-03    |
      | 100000     | 2021-02-13    |
      | 100000     | 2021-02-06    |
      | 100000     | 2021-02-13    |
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 23            | 3825          | 900000           | 903825                  | 900000                        |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 10            | 2182          | 400000           | 402182                  | 400000                        |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 27            | 1342          | 1000000                       | 1000000                            |
      | 2021-02-03 | 2021-02-02 | 0          | 1       | 24            | 0             | 900000                        | 900000                             |
      | 2021-02-03 | 2021-02-05 | 3          | 1       | 19            | 57            | 700000                        | 700000                             |
      | 2021-02-06 | 2021-02-12 | 7          | 1       | 16            | 115           | 600000                        | 600000                             |
      | 2021-02-13 | 2021-02-12 | 0          | 1       | 13            | 0             | 500000                        | 500000                             |
      | 2021-02-13 | 2021-04-14 | 61         | 1       | 10            | 668           | 400000                        | 400000                             |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 13            | 1643          | 500000           | 501643                  | 500000                        |
    And the 2nd debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 120        | 1       | 13            | 1643          | 500000                        | 500000 |