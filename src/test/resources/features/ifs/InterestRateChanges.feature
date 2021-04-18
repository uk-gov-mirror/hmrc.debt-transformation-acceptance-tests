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

  Scenario: Interest rate changes from 1% to 2.6%
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 500000            | 500000              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 13690                | 500000           | 513690             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 0                 | 500000               | 500000             | 500000               |
      | 2020-02-01 | 2020-04-06 | 66           | 1            | 13                      | 904               | 500904               | 500904             | 500000               |
      | 2020-04-07 | 2020-03-31 | 359          | 2.6          | 35                      | 12786             | 500000               | 500000             | 500000               |

  Scenario: Interest rate changes from 0% to 1%
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-03-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 500000            | 500000              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 13690                | 500000           | 513690             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | amountOnIntDueWindow | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 500000               | 0                 | 500000             | 500000               |
      | 2020-02-01 | 2020-03-31 | 60           | 1            | 13                      | 500904               | 780               | 500780             | 500000               |

  #Scenario: Interest rate changes from 1% to 0%

  Scenario: Interest rate changes from 1% to 2.6% after a payment is made
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2020-03-15    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 500000            | 500000              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 13690                | 500000           | 513690             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 0                 | 500000             | 500000               | 500000               |
      | 2020-02-01 | 2020-03-14 | 43           | 1            | 13                      | 560               | 500560             | 500560               | 500000               |
      | 2021-03-15 | 2021-04-06 | 23           | 1            | 13                      | 300               | 400300             | 400300               | 400000               |
      | 2020-04-07 | 2020-03-31 | 359          | 2.6          | 35                      | 12786             | 400000             | 400000               | 400000               |

  Scenario: 2 Debts - Interest rate changes from 1% to 2.6% and then multiple payments are made for both debts
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2021-03-31        | 1525      | 1000     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-03-15    |
      | 100000     | 2021-04-15    |
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-16  | 2021-04-14        | 1545      | 1090     | true            |
    And the debt item has payment history
      | amountPaid | dateOfPayment |
      | 100000     | 2021-01-20    |
      | 100000     | 2021-03-10    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 23                   | 3092                 | 900000            | 903092              | 900000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 10                      | 1449                 | 400000           | 401449             | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 0                 | 500000             | 500000               | 500000               |
      | 2020-02-01 | 2020-03-14 | 43           | 1            | 13                      | 560               | 500560             | 500560               | 500000               |
      | 2021-03-15 | 2021-04-06 | 23           | 1            | 13                      | 300               | 400300             | 400300               | 400000               |
      | 2020-04-07 | 2020-03-31 | 359          | 2.6          | 35                      | 12786             | 400000             | 400000               | 400000               |
    And the 2nd debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 13                      | 1643                 | 500000           | 501643             | 500000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 0                 | 500000             | 500000               | 500000               |
      | 2020-02-01 | 2020-03-14 | 43           | 1            | 13                      | 560               | 500560             | 500560               | 500000               |
      | 2021-03-15 | 2021-04-06 | 23           | 1            | 13                      | 300               | 400300             | 400300               | 400000               |
      | 2020-04-07 | 2020-03-31 | 359          | 2.6          | 35                      | 12786             | 400000             | 400000               | 400000               |

  Scenario: Interest rate changes from 1% to 2.6% - dateCalculationTo before interestStartDate
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-01-31        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 500000            | 500000              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 35                      | 13690                | 500000           | 513690             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 0                 | 500000               | 500000             | 500000               |