Feature: Interest Rate Changes
# originalAmount (Amount) = 500,000
# dateCreated (Date Amount) = 01/01/2020
# mainTrans (Regime = DRIER) = 1525, 1545
# subTrans (CHARGE_TYPE == Duty Repaid in Error - National Insurance) = 1000, 1090
# interestStartDate (Interest start date = Date Amount) 01/02/2020
# interestRateDate (New data item) = 07/04/2020
# Interest requested to (add in old value) 31/03/2019
# No repayments
# No suppression
# No breathing space


  Scenario: Interest rate changes from 3% to 3.25%
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2017-12-01  | 2017-12-01        | 2019-03-31          | 1525      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 44                   | 20650                | 500000            | 520650         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | true            | 44                      | 20650                | 500000           | 520650             | 484                  | 500000             | false                 |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2017-12-01 | 2018-08-20 | 262          | 3.0          | 41                      | 10767             | 500000               | 510767             |
      | 2018-08-21 | 2019-03-31 | 222          | 3.25         | 44                      | 9883              | 500000               | 509883             |

  Scenario: Interest rate changes from 3% to 3.25% with 2 payments on same date in a leap year
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2019-01-01  | 2019-01-01        | 2020-03-31          | 1525      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2020-02-01  |
      | 100000        | 2020-02-01  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 22                   | 19188                | 300000            | 319188         | 300000              |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 849                  |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow |
      | 2019-01-01 | 2019-12-31 | 364          | 3.25         | 17                      | 6482              | 206482             | 200000               |
      | 2020-01-01 | 2020-02-01 | 32           | 3.25         | 17                      | 568               | 200568             | 200000               |
      | 2019-01-01 | 2019-12-31 | 364          | 3.25         | 26                      | 9723              | 309723             | 300000               |
      | 2020-01-01 | 2020-03-29 | 89           | 3.25         | 26                      | 2370              | 302370             | 300000               |
      | 2020-03-30 | 2020-03-31 | 2            | 2.75         | 22                      | 45                | 300045             | 300000               |


  Scenario: Interest rate changes from 3% to 3.25%
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2017-12-01  | 2017-12-01        | 2019-03-31          | 1525      | 1000     | true            |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 44                   | 20650                | 500000            | 520650         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | true            | 44                      | 20650                | 500000           | 520650             | 484                  | 500000             | false                 |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2017-12-01 | 2018-08-20 | 262          | 3.0          | 41                      | 10767             | 500000               | 510767             |
      | 2018-08-21 | 2019-03-31 | 222          | 3.25         | 44                      | 9883              | 500000               | 509883             |

#  Scenario: Interest rate changes from non-interest bearing to interest bearing
  #Scenario: Interest rate changes from interest bearing to non-interest bearing
  #TBD: No test data currently available to implement this scenario
  Scenario: Interest rate changes from 3% to 3.25% after a payment is made
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-01-01  | 2018-01-01        | 2019-03-31          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2018-03-15  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 16100                | 400000            | 416100         | 400000              |
    And the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty |
      | true            | 35                      | 16100                | 400000           | 416100             | 526                  | 400000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | interestRate | interestDueDailyAccrual | amountOnIntDueWindow |
      | 2018-01-01 | 2018-03-15 | 3.0          | 8                       | 100000               |
      | 2018-01-01 | 2018-08-20 | 3.0          | 32                      | 400000               |
      | 2018-08-21 | 2019-03-31 | 3.25         | 35                      | 400000               |

  Scenario: Interest rate changes from 3% to 3.25% with 2 payments on same date
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-01-01  | 2018-01-01        | 2019-03-31          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2018-09-01  |
      | 100000        | 2018-09-01  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal |
      | 26                   | 15617                | 300000            | 315617         |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | interestRate | interestDueWindow |
      | 2018-01-01 | 2018-08-20 | 3.0          | 3797              |
      | 2018-08-21 | 2018-09-01 | 3.25         | 195               |
      | 2018-01-01 | 2018-08-20 | 3.0          | 5695              |
      | 2018-08-21 | 2019-03-31 | 3.25         | 5930              |


  Scenario: 2 Debts - Interest rate changes from 3% to 3.25% and then multiple payments are made for both debts
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-01-01  | 2018-01-01        | 2019-03-31          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2019-03-15  |
      | 100000        | 2019-04-15  |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-01-16  | 2018-01-16        | 2019-04-14          | 1545      | 1090     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2019-01-20  |
      | 100000        | 2019-03-10  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | amountOnIntDueTotal |
      | 52                   | 37687                | 637687         | 600000              |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | totalAmountIntDuty | amountOnIntDueDuty |
      | 1358                 | 26                      | 19365                | 319365             | 300000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | interestRate | interestDueDailyAccrual | interestDueWindow |
      | 2018-01-01 | 2018-08-20 | 3.0          | 8                       | 1898              |
      | 2018-08-21 | 2019-04-15 | 3.25         | 8                       | 2110              |
      | 2018-01-01 | 2018-08-20 | 3.0          | 8                       | 1898              |
      | 2018-08-21 | 2019-03-15 | 3.25         | 8                       | 1834              |
      | 2018-01-01 | 2018-08-20 | 3.0          | 24                      | 5695              |
      | 2018-08-21 | 2019-03-31 | 3.25         | 26                      | 5930              |
    And the 2nd debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 1237                 | 26                      | 18322                | 318322             | 300000             |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | interestRate | interestDueDailyAccrual | interestDueWindow |
      | 2018-01-16 | 2018-08-20 | 3.0          | 8                       | 1775              |
      | 2018-08-21 | 2019-03-10 | 3.25         | 8                       | 1789              |
      | 2018-01-16 | 2018-08-20 | 3.0          | 8                       | 1775              |
      | 2018-08-21 | 2019-01-20 | 3.25         | 8                       | 1353              |
      | 2018-01-16 | 2018-08-20 | 3.0          | 24                      | 5326              |
      | 2018-08-21 | 2019-04-14 | 3.25         | 26                      | 6304              |


  Scenario: Interest rate changes from 2.75% to 2.6% - interestRequestedTo before interestStartDate
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2020-01-01  | 2020-04-10        | 2020-03-31          | 1525      | 1000     | true            |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal |
      | 0                    | 0                    | 500000         |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays |
      | true            | 0                    |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | interestRate |
      | 2020-04-10 | 2020-03-31 | 0.0          |