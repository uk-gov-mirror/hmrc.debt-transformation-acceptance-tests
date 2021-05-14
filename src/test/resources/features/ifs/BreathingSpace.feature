#  Assumptions
#  NO suppression period

# DTD-185. Breathing Space

# Scenario 1. Breathing Space applied to 1 debt
# Scenario 2. Breathing Space - open ended

#  Scenarios TBC and will be added below
# Breathing space applied to more than 1 debt
# Breathing space applied where payments are made
# More than one breathing space not overlapping
# Payments being made or interest rate change while breathing space is applied

Feature: Breathing Space

  Scenario: Breathing Space applied to 1 debt
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2021-03-01  | 2021-03-01        | 2021-03-20          | 1530      | 1000     |
    And the debt item has no payment history
    And the customer has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2021-03-07      | 2021-03-10    |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 569                  | 500000            | 500569         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 16                   | 35                      | 569                  | 500000           | 500569             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2021-03-01 | 2021-03-06 | 5            | 2.6          | 35                      | 178               | 500000               | 500178             |
      | 2021-03-07 | 2021-03-10 | 3            | 0.0          | 0                       | 0                 | 500000               | 500000             |
      | 2021-03-10 | 2021-03-20 | 11           | 2.6          | 35                      | 391               | 500000               | 500391             |

  Scenario: Breathing Space - open ended
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2021-03-01  | 2021-03-01        | 2021-03-20          | 1530      | 1000     |
    And the debt item has no payment history
    And the customer has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2021-03-07      |               |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | amountIntTotal |
      | 0                    | 500178         |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | true            | 5                    | 0                       | 500178             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow |
      | 2021-03-01 | 2021-03-06 | 5            | 2.6          | 35                      | 178               |
      | 2021-03-07 | 2021-03-20 | 13            | 0.0          | 0                       | 0                 |
