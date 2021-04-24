# originalAmount (Amount) = 500,000
# dateCreated (Date Amount) = 01/01/2020
# mainTrans (Regime = DRIER) = 1525, 1545
# subTrans (CHARGE_TYPE == Duty Repaid in Error - National Insurance) = 1000, 1090
# interestStartDate (Interest start date = Date Amount) 01/02/2020
# interestRateDate (New data item) = 07/04/2020
# Interest requested to (add in old value) 31/03/2021
# No repayments
# No suppression
# No breathing space


# DTD-172 - Request interest for Drier case (interest rate changes)

Feature: Interest Rate Changes

  Scenario: Interest rate changes from 2.75% to 2.6%
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-01-01        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 35                   | 16930                | 500000            | 516930              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 16930                | 500000           | 516930             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 44                      | 3917              | 500000               | 503917             |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 37                      | 263               | 500000               | 500263             |
      | 2020-04-07 | 2021-03-31 | 358          | 2.6          | 35                      | 12750             | 500000               | 512750             |

  Scenario: Interest rate changes from non-interest bearing to interest bearing
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-03-06        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 35                   | 14036                | 500000            | 514036              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 14036                | 500000           | 514036             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-03-06 | 2020-03-29 | 23           | 3.25         | 44                      | 1023              | 500000               | 501023             |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 37                      | 263               | 500000               | 500263             |
      | 2020-04-07 | 2021-03-31 | 358          | 2.6          | 35                      | 12750             | 500000               | 512750             |

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
      | 28                   | 14202                | 400000            | 414202              | 400000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 28                      | 14202                | 400000           | 414202            | 531                    | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-03-15 | 74           | 3.25         | 8                       | 658               | 100658             | 100000               |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 35                      | 3134              | 403134             | 400000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 30                      | 210               | 400210             | 400000               |
      | 2020-04-07 | 2021-03-31 | 358          | 2.6          | 28                      | 10200             | 410200             | 400000               |

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
      | 42                   | 32832                | 600000            | 632832              | 600000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 21                      | 16920                | 300000           | 316920             | 300000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 8                       | 783               | 100783             | 100000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 7                       | 52                | 100052             | 100000               |
      | 2020-04-07 | 2021-03-15 | 342          | 2.6          | 7                       | 2436              | 102436             | 100000               |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 8                       | 783               | 100783             | 100000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 7                       | 52                | 100052             | 100000               |
      | 2020-04-07 | 2021-04-15 | 373          | 2.6          | 7                       | 2656              | 102656             | 100000               |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 26                      | 2350              | 302350             | 300000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 22                      | 158               | 300158             | 300000               |
      | 2020-04-07 | 2021-03-31 | 358          | 2.6          | 21                      | 7650              | 307650             | 300000               |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 21                      | 15912                | 300000           | 315912             | 300000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-16 | 2020-03-29 | 73           | 3.25         | 8                       | 650               | 100650             | 100000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 7                       | 52                | 100052             | 100000               |
      | 2020-04-07 | 2021-01-20 | 288          | 2.6          | 7                       | 2051              | 102051             | 100000               |
      | 2020-01-16 | 2020-03-29 | 73           | 3.25         | 8                       | 650               | 100650             | 100000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 7                       | 52                | 100052             | 100000               |
      | 2020-04-07 | 2021-03-10 | 337          | 2.6          | 7                       | 2400              | 102400             | 100000               |
      | 2020-01-16 | 2020-03-29 | 73           | 3.25         | 26                      | 1950              | 301950             | 300000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 22                      | 158               | 300158             | 300000               |
      | 2020-04-07 | 2021-04-14 | 372          | 2.6          | 21                      | 7949              | 307949             | 300000               |

  Scenario: Interest rate changes from 2.75% to 2.6% - dateCalculationTo before interestStartDate
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-04-10        | 2020-03-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 500000            | 500000              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 0                       | 0                    | 500000           | 500000             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-04-10 | 2020-03-31 | 0            | 0.0          | 0                       | 0                 | 500000               | 500000             |