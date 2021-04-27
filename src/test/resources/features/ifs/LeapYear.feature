

Feature: Leap years

  Scenario: Debt ending in a leap year
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-01-01  | 2018-01-01        | 2020-04-01        | 1525      | 1000     | true            |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 37                   | 35601                | 500000            | 535601              | 500000              |
    And the 1st debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 818          | 37                      | 35601                | 500000           | 535601             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2018-01-01 | 2018-08-20 | 231          | 3.0          | 41                      | 9493              | 500000               | 509493             |
      | 2018-08-21 | 2019-12-31 | 497          | 3.25         | 44                      | 22126             | 500000               | 522126             |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 44                      | 3907              | 500000               | 503907             |
      | 2020-03-30 | 2020-04-01 | 2            | 2.75         | 37                      | 75                | 500000               | 500075             |


  Scenario: Debt starting in a leap year
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-05-02  | 2020-05-02        | 2021-05-01        | 1525      | 1000     | true            |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 35                   | 12904                | 500000            | 512904              | 500000              |
    And the 1st debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 363          | 35                      | 12904                | 500000           | 512904             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2020-05-02 | 2020-12-31 | 243          | 2.6          | 35                      | 8631              | 500000               | 508631             |
      | 2021-01-01 | 2021-05-01 | 120          | 2.6          | 35                      | 4273              | 500000               | 504273             |

  Scenario: Debt crossing a leap year
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-01-01  | 2018-01-01        | 2021-04-01        | 1525      | 1000     | true            |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 35                   | 48512                | 500000            | 548512              | 500000              |
    And the 1st debt summary will contain
      | numberOfDays | interestDueDailyAccrual | interestDueDebtTotal | unpaidAmountDebt | totalAmountIntDebt | numberChargeableDays | amountOnIntDueDebt |
      | 1181         | 35                      | 48512                | 500000           | 548512             | 0                    | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2018-01-01 | 2018-08-20 | 231          | 3.0          | 41                      | 9493              | 500000               | 509493             |
      | 2018-08-21 | 2019-12-31 | 497          | 3.25         | 44                      | 22126             | 500000               | 522126             |
      | 2020-01-01 | 2020-03-29 | 88           | 3.25         | 44                      | 3907              | 500000               | 503907             |
      | 2020-03-30 | 2020-04-06 | 7            | 2.75         | 37                      | 262               | 500000               | 500262             |
      | 2020-04-07 | 2020-12-31 | 268          | 2.6          | 35                      | 9519              | 500000               | 509519             |
      | 2021-01-01 | 2021-04-01 | 90           | 2.6          | 35                      | 3205              | 500000               | 503205             |
