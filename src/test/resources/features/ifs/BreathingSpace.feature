#  Assumptions
#  NO suppression period

# DTD-185. Breathing Space

#1. Breathing Space applied to 1 debt

#  Scenarios tbc and added below
# Breathing space applied to more than 1 debt
# Breathing space with no end date (in this scenario the window would end at the calculation too date - so the UI is able to calculate ' number of days', 'daily accrual'. )
# Breathing space applied where payments are made
# More than one breathing space not overlapping
# Payments being made or interest rate change while breathing space is applied


Feature: Breathing Space
@runMe
  Scenario: Breathing Space applied to 1 debt
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-02-01        | 2021-11-30        | 1530      | 1000     | true            |
    And the debt item has no payment history
    And the customer has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2020-04-07      | 2020-06-06    |
      | 2020-04-08      | 2020-06-02    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 28                   | 21689                | 500000            | 521689              | 500000              |
    And the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | amountOnIntDueDebt |
      | 28                      | 21689                | 500000           | 521689             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-01-01 | 2020-01-31 | 31           | 0            | 0                       | 0                 | 500000               | 500000             |
      | 2020-02-01 | 2020-04-06 | 66           | 2.6          | 35                      | 2350              | 500000               | 500000             |
      | 2020-04-07 | 2020-06-06 | 60           | 0            | 0                       | 0                 | 500000               | 500000             |
      | 2020-06-07 | 2021-11-30 | 543          | 2.6          | 35                      | 19339             | 519339               | 500000             |
