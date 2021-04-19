# originalAmount (Amount) = 500,000
# dateCreated (Date Amount) = 01/01/2020
# mainTrans (Regime = DRIER) = 1085
# subTrans (CHARGE_TYPE == Duty Repaid in Error - National Insurance) = 1025
# interestStartDate (Interest start date = Date Amount) 01/02/2020
# interestRateDate (New data item) = 07/04/2020
# Interest requested to (add in old value) 31/03/2021
# No repayments
# No suppression
# No breathing space


# DTD-172 - Request interest for Drier case (interest rate changes)

Feature: Request interest for Drier case (interest rate changes)

  Scenario: Interest rate changes from 2.75% to 2.6%
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-01-01        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 35                   | 17049                | 500000            | 517049              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 17049                | 500000           | 517049             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-01-01 | 2020-03-29 | 89           | 3.25         | 44                      | 3962              | 503962               | 500000             |
      | 2020-03-30 | 2020-04-06 | 8            | 2.75         | 37                      | 301               | 500301               | 500000             |
      | 2020-04-07 | 2021-03-31 | 359          | 2.6          | 35                      | 12786             | 512786               | 500000             |

  Scenario: Interest rate changes from non-interest bearing to interest bearing
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-03-06        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 35                   | 14155                | 500000            | 514155              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 14155                | 500000           | 514155             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-01-01 | 2020-03-05 | 0            | 0.0          | 0                       | 0                 | 500000               | 500000             |
      | 2020-03-06 | 2020-03-29 | 24           | 3.25         | 44                      | 1068              | 501068               | 500000             |
      | 2020-03-30 | 2020-04-06 | 8            | 2.75         | 37                      | 301               | 500301               | 500000             |
      | 2020-04-07 | 2021-03-31 | 359          | 2.6          | 35                      | 12786             | 512786               | 500000             |
    
  #Scenario: Interest rate changes from interest bearing to non-interest bearing
  #TBD: No test data currently available to implement this scenario

  Scenario: Interest rate changes from 2.75% to 2.6% after a payment is made
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-01-01        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2020-03-15    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 28                   | 14298                | 400000            | 414298              | 400000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 28                      | 14298                | 400000           | 414298             | 0                    | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-03-14 | 74           | 3.25         | 44                      | 3294              | 500000             | 500000               |
      | 2020-03-15 | 2020-03-29 | 15           | 3.25         | 35                      | 534               | 400000             | 400000               |
      | 2020-03-30 | 2020-04-06 | 8            | 2.75         | 30                      | 241               | 400000             | 400000               |
      | 2020-04-07 | 2021-03-31 | 359          | 2.6          | 28                      | 10229             | 400000             | 400000               |

  Scenario: 2 Debts - Interest rate changes from 2.75% to 2.6% and then multiple payments are made for both debts
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-01-01        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-03-15    |
      | 100000     | 2021-04-15    |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-16  | 2020-01-16        | 2021-04-14        | 1545      | 1090     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-01-20    |
      | 100000     | 2021-03-10    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 49                   | 32944                | 700000            | 732944              | 700000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 28                      | 16927                | 400000           | 416927             | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-03-29 | 89           | 3.25         | 44                      | 3962              | 500000             | 500000               |
      | 2020-03-30 | 2020-04-06 | 8            | 2.75         | 37                      | 301               | 500000             | 500000               |
      | 2020-04-07 | 2021-03-14 | 342          | 2.6          | 35                      | 12180             | 500000             | 500000               |
      | 2021-03-15 | 2021-03-31 | 17           | 2.6          | 28                      | 484               | 400000             | 400000               |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 21                      | 16017                | 300000           | 316017             | 300000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-16 | 2020-03-29 | 74           | 3.25         | 44                      | 3294              | 500000             | 500000               |
      | 2020-03-30 | 2020-04-06 | 8            | 2.75         | 37                      | 301               | 500000             | 500000               |
      | 2020-04-07 | 2021-01-19 | 288          | 2.6          | 35                      | 10257             | 500000             | 500000               |
      | 2021-01-20 | 2021-03-09 | 49           | 2.6          | 28                      | 1396              | 400000             | 400000               |
      | 2021-03-10 | 2021-04-14 | 36           | 2.6          | 21                      | 769               | 300000             | 300000               |

  Scenario: Interest rate changes from 2.75% to 2.6% - dateCalculationTo before interestStartDate
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-01-01        | 2020-01-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 44                   | 1380                 | 500000            | 501380              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 44                      | 1380                 | 500000           | 501380             | 31                   | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 3.25         | 44                      | 1380              | 500000               | 500000             |