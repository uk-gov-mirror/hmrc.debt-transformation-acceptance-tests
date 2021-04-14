#  Assumptions
#  Initial originalAmount and date
#  MainTrans == 1525 (TPSS)
#  NO suppression period
#  NO breathing space
#  Date Amount  == Interest start date


# DTD-171. Multiple Debt Items
#1. 1 payment of 1 debt no interest
#2. 1 payment of 1 debt with interest
#3. 2 payments of 1 debt with interest
#4. 2 debts, 1 debt with a payment, the second debt with no payment

Feature: Multiple Debt Items

  Scenario: 1. Non Interest Bearing. 1 Payment of 1 debt.
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1520  | 1000       | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0             | 0             | 400000           | 400000                  | 400000                        |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 0             | 0             | 400000           | 400000                  | 0                    | 400000                        |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 0          | 0       | 0             | 0             | 500000                        | 500000                             |
      | 2021-02-03 | 2021-04-14 | 0          | 0       | 0             | 0             | 400000                        | 400000                             |

  Scenario: 2. Interest Bearing. 1 Payment of 1 debt.
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 10            | 1449          | 400000           | 401449                  | 400000                        |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 10            | 1449          | 400000           | 401449                  | 400000                        |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        | 500000                             |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        | 400000                             |


  Scenario: 3. Interest Bearing. 2 Payments of 1 debt.
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | 1525  | 1000         | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-23    |
      | 100000     | 2021-03-05    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 8             | 1390          | 300000           | 301390                  | 300000                        |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 8             | 1390          | 300000           | 301390                  | 300000                        |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-22 | 69         | 1       | 13            | 945           | 500000                        | 500000                               |
      | 2021-02-23 | 2021-03-04 | 10         | 1       | 10            | 109           | 400000                        | 400000                               |
      | 2021-03-05 | 2021-04-14 | 41         | 1       | 8             | 336           | 300000                        | 300000                               |

  Scenario: 4. Interest Bearing. 2 debts. 1 debt with payment the second debt with no payment.
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
      | 23            | 3092          | 900000           | 903092                  | 900000                        |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 10            | 1449          | 400000           | 401449                  | 400000                        |
    And the 1st debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-02 | 49         | 1       | 13            | 671           | 500000                        | 500000                             |
      | 2021-02-03 | 2021-04-14 | 71         | 1       | 10            | 778           | 400000                        | 400000                             |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 13            | 1643          | 500000           | 501643                  | 500000                        |
    And the 2nd debt summary will have calculation windows
      | periodFrom   | periodTo     | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 120        | 1       | 13            | 1643          | 500000                        |  500000                            |

