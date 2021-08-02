#  Assumptions
#  1 Debt item
#  Initial originalAmount and date
#  MainTrans == 1525 (TPSS)
#  Where mainTrans is 1525 and subTrans is 1000, then interest bearing is assumed to be true
#  Where subTrans is 1000 HiPG, then interest bearing is assumed to be false
#  NO repayments
#  NO suppression period
#  NO breathing space
#  Date Amount  == Interest start date
#  No outstanding interests to pay
#  When bearing the interest rate is 1%

#  DTD-170 Get Debt For MainTrans (1525) case

Feature: Debt Calculation For TPSS MainTrans 1525 case

  Scenario: Interest Bearing TPSS MainTrans 1525 debt
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-01        | 2021-03-08          | 1525      | 1000     | true            |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 249                  | 500000            | 500249         | 500000              |
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | true            | 35                      | 249                  | 2.6     | 500000           | 500249             | 7                    | 500000             | false                 |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2021-03-01 | 2021-03-08 | 7            | 2.6          | 35                      | 249               | 500000               | 500249             |

  Scenario: Non Interest Bearing TPSS MainTrans 1525 debt
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-01        | 2021-03-08          | 1520      | 1090     | false           |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 500000            | 500000         | 500000              |
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | false           | 0                       | 0                    | 0       | 500000           | 500000             | 0                    | 500000             | false                 |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2021-03-01 | 2021-03-08 | 0            | 0.0          | 0                       | 0                 | 500000               | 500000             |

  @dtd-509 @wip
  Scenario: interestBearing flag should be true where amount has been paid off. Payment date AFTER interest start date (for bug DTD-509)
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-01        | 2021-03-08          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 500000        | 2021-03-04  |
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 0                    | 106                  | 0                 | 106            | 0                   |
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | true            | 0                       | 106                  | 2.6     | 0                | 106                | 3                    | 0                  | false                 |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2021-03-01 | 2021-03-04 | 3            | 2.6          | 35                      | 106               | 500000               | 500106             |

  @dtd-509 @wip
  Scenario: interestBearing flag should be true even when debt has been paid off. Payment date BEFORE interest start date (for bug DTD-509)
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-01        | 2021-03-08          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 500000        | 2021-02-04  |
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 0                 | 0              | 0                   |
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | true            | 0                       | 0                    | 2.6     | 0                | 0                  | 0                    | 0                  | false                 |

  Scenario: Non Interest Bearing where amount has been paid off
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-01        | 2021-06-08          | 1520      | 1090     | false           |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 300000        | 2021-03-23  |
      | 200000        | 2021-04-05  |
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 0                 | 0              | 0                   |
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | false           | 0                       | 0                    | 0       | 0                | 0                  | 0                    | 0                  | false                 |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2021-03-01 | 2021-04-05 | 0            | 0.0          | 0                       | 0                 | 200000               | 200000             |
      | 2021-03-01 | 2021-03-23 | 0            | 0.0          | 0                       | 0                 | 300000               | 300000             |
