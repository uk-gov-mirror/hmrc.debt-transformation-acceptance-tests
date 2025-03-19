@suppression

Feature: Suppression - Period End
  Scenario: Suppression applied to period End - on last day of suppression
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
      | 2021-04-04 | 2021-05-04 | LEGISLATIVE | COVID      | SA-Suppression               | true           |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2021-05-04 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 4415                 | 500000            | 504415         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 124                  | 35                      | 4415                 | 500000           | 504415             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | reason      | code                                 | description |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 35                      | 502172             |             |                                      |             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 500000             | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      | 502243             |             |                                      |             |


  Scenario: Suppression applied to period End - on first day of suppression
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
      | 2021-04-04 | 2021-05-04 | LEGISLATIVE | COVID      | SA-Suppression               | true           |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2021-05-04 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 4415                 | 500000            | 504415         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 124                  | 35                      | 4415                 | 500000           | 504415             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | reason      | code                                 | description |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 35                      | 502172             |             |                                      |             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 500000             | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      | 502243             |             |                                      |             |


  Scenario: Suppression applied to period End - on some day during suppression
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
      | 2021-04-04 | 2021-05-04 | LEGISLATIVE | COVID      | SA-Suppression               | true           |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2021-04-30 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 4415                 | 500000            | 504415         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 124                  | 35                      | 4415                 | 500000           | 504415             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | reason      | code                                 | description |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 35                      | 502172             |             |                                      |             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 500000             | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      | 502243             |             |                                      |             |


  Scenario: Suppression should NOT be applied for non matching period End
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
      | 2021-04-04 | 2021-05-04 | LEGISLATIVE | COVID      | SA-Suppression               | true           |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2020-12-20 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 35                   | 5520                 | 505520         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 155                  | 35                      | 5520                 | 500000           | 505520             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason | description | code |
      | 2021-02-01 | 2021-07-06 | 155          | 2.6          | 35                      | 505520             | false                 |        |             |      |


  Scenario: Period End Suppression should NOT be applied where suppression period is before interest start date
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
      | 2019-02-04 | 2019-05-04 | LEGISLATIVE | COVID      | SA-Suppression               | true           |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2021-05-20 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 35                   | 5520                 | 505520         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 155                  | 35                      | 5520                 | 500000           | 505520             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason | description | code |
      | 2021-02-01 | 2021-07-06 | 155          | 2.6          | 35                      | 505520             | false                 |        |             |      |


  Scenario: Period End Suppression should NOT be applied where suppression start is same day as interest requested to
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
      | 2024-07-06 | 2024-08-01 | LEGISLATIVE | COVID      | SA-Suppression               | true           |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2024-02-01        | 2024-07-06          | 1535      | 1000     | 2024-05-20 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 88                   | 13852                | 513852         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 156                  | 88                      | 13852                | 500000           | 513852             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason | description | code |
      | 2024-02-01 | 2024-07-06 | 156          | 6.5          | 88                      | 513852             | false                 |        |             |      |

  ##TODO when periodEnd is a calendar date
#  Scenario: Suppression for multiple period ends
#    Given suppression configuration data is created
#
#      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
#      | 2021-04-04 | 2021-05-04 | LEGISLATIVE | COVID      | SA-Suppression               | true           |
#    When suppression configuration is sent to ifs service
#    Given suppression data has been created
#      | reason | description | enabled | fromDate   | toDate     |
#      | POLICY | COVID       | true    | 2021-04-04 | 2021-05-04 |
#    And suppression rules have been created
#      | ruleId | periodEnd  | suppressionIds |
#      | 1      | 2020-11-20 | 1              |
#      | 1      | 2020-12-20 | 1              |
#      | 1      | 2022-12-20 | 1              |
#    And a debt item
#      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
#      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2020-12-20 |
#    And the debt item has no payment history
#    And no breathing spaces have been applied to the debt item
#    And no post codes have been provided for the customer
#    When the debt item is sent to the ifs service
#    Then the ifs service wilL return a total debts summary of
#      | interestDueCallTotal |
#      | 4415                 |
#    And the 1st debt summary will have calculation windows
#      | periodFrom | periodTo   | numberOfDays | interestRate |
#      | 2021-02-01 | 2021-04-03 | 61           | 2.6          |
#      | 2021-04-04 | 2021-05-04 | 31           | 0.0          |
#      | 2021-05-05 | 2021-07-06 | 63           | 2.6          |


  Scenario: Suppression  periodEnd and postcode
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | postcode | checkPeriodEnd |
      | 2020-12-04 | 2021-03-01 | LEGISLATIVE | COVID      | SA-Suppression               | TW3 4PR  | true           |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2020-12-20 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4PR  | 2020-12-01   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 35                   | 4523                 | 504523         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 127                  | 35                      | 4523                 | 500000           | 504523             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2021-02-01 | 2021-03-01 | 28           | 0.0          | 0                       | 500000             | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2021-03-02 | 2021-07-06 | 127          | 2.6          | 35                      | 504523             | false                 |             |             |                                      |


  Scenario: Suppression for multiple period ends, postcode and main trans
    Given suppression configuration data is created
      | dateFrom   | dateTo     | reason      | reasonDesc | suppressionChargeDescription | postcode | checkPeriodEnd | mainTrans |
      | 2020-12-04 | 2021-03-01 | LEGISLATIVE | COVID      | SA-Suppression               | TW3 4PR  | true           | 1535      |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | periodEnd  |
      | 500000         | 2021-02-01        | 2021-07-06          | 1535      | 1000     | 2020-12-20 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4PR  | 2020-12-01   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 35                   | 4523                 | 504523         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 127                  | 35                      | 4523                 | 500000           | 504523             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2021-02-01 | 2021-03-01 | 28           | 0.0          | 0                       | 500000             | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2021-03-02 | 2021-07-06 | 127          | 2.6          | 35                      | 504523             | false                 |             |             |                                      |

