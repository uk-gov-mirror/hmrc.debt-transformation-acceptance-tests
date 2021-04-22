#  Assumptions
#  NO suppression period

# DTD-185. Breathing Space

# Scenario 1. Breathing Space applied to 1 debt
# Scenario 2. No Breathing space applied

# Note: Have used years 2014 and 2015 to simplify caluclation windows. eg non leap years and no interest rate changes.

#  Scenarios TBC and will be added below
# Breathing space applied to more than 1 debt
# Breathing space with no end date (in this scenario the window would end at the calculation too date - so the UI is able to calculate ' number of days', 'daily accrual'. )
# Breathing space applied where payments are made
# More than one breathing space not overlapping
# Payments being made or interest rate change while breathing space is applied


Feature: Breathing Space

  Scenario: Breathing Space applied to 1 debt
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2014-01-01  | 2014-02-01        | 2015-11-30        | 1530      | 1000     | true            |
    And the debt item has no payment history
    And the customer has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2014-04-07      | 2014-06-06    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 28                   | 21689                | 500000            | 521689              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 28                      | 21689                | 500000           | 521689             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2014-01-01 | 2014-01-31 | 31           | 0            | 0                       | 0                 | 500000               | 500000             |
      | 2014-02-01 | 2014-04-06 | 65           | 3.0          | 41                      | 2671              | 500000               | 502671             |
      | 2014-04-07 | 2014-06-06 | 61           | 0            | 0                       | 0                 | 500000               | 500000             |
      | 2014-06-07 | 2015-11-30 | 542          | 3.0          | 41                      | 22273             | 500000               | 522273             |

  Scenario: No breathing space applied
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2014-01-01  | 2014-02-01        | 2015-11-30        | 1530      | 1000     | true            |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 41                   | 27452                | 500000            | 527452              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 41                      | 27452                | 500000           | 527452             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 0                 | 500000               | 500000             |
      | 2020-02-01 | 2021-11-30 | 668          | 3.0          | 41                      | 27452             | 500000               | 527452             |
