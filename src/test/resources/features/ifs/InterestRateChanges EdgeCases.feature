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
Feature: Interest Rate Changes - Edge cases


  Scenario: 300 Debt items - Interest rate changes from 2.75% to 2.6%
    Given 300 debt items where interest rate changes from 2.75 to 2.6
    When the debt items is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 10500                | 1499700              | 150000000         | 151499700           | 150000000           |
    And the 300th debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 35                      | 4999                 | 500000           | 504999             | 500000             |

  Scenario: 2 Debts - Interest rate changes from 3.25% to 2.75% - payment is made for 1 debt - Interest rate changes from 2.75% to 2.6%
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-06-01  | 2018-06-01        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2019-03-15    |
      | 100000     | 2020-04-15    |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-01-01  | 2018-01-01        | 2020-05-31        | 1545      | 1090     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 56                   | 71674                | 800000            | 871674              | 800000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 21                      | 33906                | 300000           | 333906             | 300000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2018-06-01 | 2018-08-20 | 80           | 3.0          | 8                       | 657               | 100657             | 100000               |
      | 2018-08-21 | 2020-03-29 | 586          | 3.25         | 8                       | 5217              | 105217             | 100000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 7                      | 52                | 100052             | 100000               |
      | 2020-04-07 | 2020-04-15 | 8            | 2.6          | 7                       | 56                | 100056             | 100000               |
      | 2018-06-01 | 2018-08-20 | 80           | 3.0          | 8                       | 657               | 100657             | 100000               |
      | 2018-08-21 | 2019-03-15 | 206          | 3.25         | 8                       | 1834              | 101834             | 100000               |
      | 2018-06-01 | 2018-08-20 | 80           | 3.0          | 24                      | 1972              | 301972             | 300000               |
      | 2018-08-21 | 2020-03-29 | 586          | 3.25         | 26                      | 15653             | 315653             | 300000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 22                      | 158               | 300158             | 300000               |
      | 2020-04-07 | 2021-03-31 | 358          | 2.6          | 21                      | 7650              | 307650             | 300000               |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 35                      | 37768                | 500000           | 537768             | 500000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2018-01-01 | 2018-08-20 | 231          | 3.0          | 41                      | 9493              | 509493             | 500000               |
      | 2018-08-21 | 2020-03-29 | 586          | 3.25         | 44                      | 26089             | 526089             | 500000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 37                      | 263               | 500263             | 500000               |
      | 2020-04-07 | 2020-05-31 | 54           | 2.6          | 35                      | 1923              | 501923             | 500000               |

  Scenario:  Interest rate changes from 2.75% to 2.6% - payment is made for 1 debt on the same day the interest rate changes
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-01-01        | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2020-04-07    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 28                   | 14387                | 400000            | 414387              | 400000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 28                      | 14387                | 400000           | 414387             | 554                  | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 8                       | 783               | 100783             | 100000               |
      | 2020-03-30 | 2020-04-07 | 8            | 2.75         | 7                       | 60                | 100060             | 100000               |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 35                      | 3134              | 403134             | 400000               |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 30                      | 210               | 400210             | 400000               |
      | 2020-04-07 | 2021-03-31 | 358          | 2.6          | 28                      | 10200             | 410200             | 400000               |


#  BUG: Test failing due to issue with interest accrued returned
#  Scenario: Interest rate changes from 0% to 8.5%
#    Given a debt item
#      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
#      | 500000         | 2000-01-01  | 2000-01-01 | 2001-03-31        | 1525      | 1000     | true            |
#    And the debt item has no payment history
#    When the debt item is sent to the ifs service
#    Then the ifs service wilL return a total debts summary of
#      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
#      | 0                    | 0                    | 500000            | 500000              | 500000              |
#    And the 1st debt summary will contain
#      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
#      | 0                       | 0                    | 500000           | 500000             | 0                    | 500000             |
#    And the 1st debt summary will have calculation windows
#      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | amountOnIntDueWindow | interestDueWindow | unpaidAmountWindow |
#      | 2000-01-01 | 2000-02-05 | 0            | 0.0          | 0                       | 500000               | 0                 | 500000             |
#      | 2000-02-06 | 2001-03-31 | 418          | 8.5          | 13                      | 500904               | 780               | 500780             |

