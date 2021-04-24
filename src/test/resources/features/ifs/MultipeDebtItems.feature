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
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1520      | 1090     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 400000            | 400000              | 400000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 0                       | 0                    | 400000           | 400000             | 0                    | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-03 | 0            | 0.0            | 0                       | 0                 | 100000               | 100000             |
      | 2020-12-16 | 2021-04-14 | 0            | 0.0            | 0                       | 0                 | 400000               | 400000             |

  Scenario: 2. Interest Bearing. 1 Payment of 1 debt.
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-03    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 28                   | 3739                 | 400000            | 403739              | 400000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 28                      | 3739                 | 400000           | 403739             | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-03 | 49           | 2.6          | 7                       | 349                | 100000               | 100349             |
      | 2020-12-16 | 2021-04-14 | 119           | 2.6          | 28                      | 3390             | 400000               | 403390             |

  Scenario: 3. Interest Bearing. 2 Payments of 1 debt.
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-12-16  | 2020-12-16        | 2021-04-14        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-02-23    |
      | 100000     | 2021-03-05    |
    When the debt items is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 21                   | 3596                 | 300000            | 303596              | 300000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 21                      | 3596                 | 300000           | 303596             | 300000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-03-05 | 79           | 2.6           | 7                       | 562               | 100000               | 100562             |
      | 2020-12-16 | 2021-02-23 | 69           | 2.6           | 7                       | 491               | 100000               | 100491             |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6           | 21                      | 2543              | 300000               | 302543             |

  Scenario: 4. Interest Bearing. 2 debts. 1 debt with payment the second debt with no payment.
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
      | 63                   | 7977                 | 900000            | 907977              | 900000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 28                      | 3739                 | 400000           | 403739             | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-02-03 | 49           | 2.6          | 7                      | 349                | 100000               | 100349             |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 28                     | 3390               | 400000               | 403390             |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 35                      | 4238                 | 500000           | 504238             | 500000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-12-16 | 2021-04-14 | 119          | 2.6          | 35                      | 4238              | 500000               | 504238             |

