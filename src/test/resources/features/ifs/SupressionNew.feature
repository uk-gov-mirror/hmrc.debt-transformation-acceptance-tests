@suppression  @2790
Feature: Suppression

  Scenario: Suppression - full address postCode
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 88                   | 9590                 | 509590         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 88                      | 9590                 | 500000           | 509590             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 500000             | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 88                      | 509590             | false                 |             |             |                                      |


  Scenario: Suppression - Partial postCode
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M     | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2024-03-03   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 88                   | 9590                 | 509590         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 88                      | 9590                 | 500000           | 509590             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 500000             | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 88                      | 509590             | false                 |             |             |                                      |


  Scenario: Suppression - Missing mainTrans
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1000     | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2024-03-03   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 88                   | 9590                 | 509590         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 88                      | 9590                 | 500000           | 509590             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 500000             | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 88                      | 509590             | false                 |             |             |                                      |


  Scenario: Suppression - Missing SubTrans
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2024-03-03   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 88                   | 9590                 | 509590         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 88                      | 9590                 | 500000           | 509590             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 500000             | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 88                      | 509590             | false                 |             |             |                                      |


  Scenario: Suppression - no checkPeriodEnd
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M 2LS | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 88                   | 9590                 | 509590         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 88                      | 9590                 | 500000           | 509590             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 500000             | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 88                      | 509590             | false                 |             |             |                                      |


  Scenario: Suppression, 2 payments on different dates during suppression
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2024-03-10  |
      | 50000         | 2024-03-15  |
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2019-07-06   |
    And no breathing spaces have been applied to the debt item
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 62                   | 6713                 | 356713         | 350000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 62                      | 6713                 | 350000           | 356713             | 350000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow | breathingSpaceApplied | reason      | code                                 | description |
      | 2024-03-01 | 2024-03-15 | 14           | 0.0          | 0                       | 0                 | 50000              | 50000                | false                 | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2024-03-01 | 2024-03-10 | 9            | 0.0          | 0                       | 0                 | 100000             | 100000               | false                 | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 0                 | 350000             | 350000               | false                 | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 62                      | 6713              | 356713             | 350000               | false                 |             |                                      |             |


  Scenario: Suppression, 2 debts 2 payments on same day for one of the debts
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2024-03-20  |
      | 50000         | 2024-03-20  |
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 400000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 133                  | 14385                | 764385         | 750000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 62                      | 6713                 | 350000           | 356713             | 350000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 0                 | 150000             | 150000               | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 0                 | 350000             | 350000               | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 62                      | 6713              | 356713             | 350000               | false                 |             |             |                                      |
    And the 2nd debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 108                  | 71                      | 7672                 | 400000           | 407672             | 400000             |
    Then the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow | breathingSpaceApplied | reason      | code                                 | description |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 0                 | 400000             | 400000               | false                 | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 71                      | 7672              | 407672             | 400000               | false                 |             |                                      |             |


  Scenario: Suppression, 2 payments after suppression dates
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2024-03-01          | 2024-03-20        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2024-03-01        | 2024-07-06          | 1535      | 1000     | EC2M 2LS | 2024-03-06 |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2024-05-01  |
      | 100000        | 2024-05-20  |
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal | amountOnIntDueTotal |
      | 53                   | 7582                 | 307582         | 300000            | 300000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 211                  | 53                      | 7582                 | 300000           | 307582             | 300000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | unpaidAmountWindow | amountOnIntDueWindow | breathingSpaceApplied | reason      | description | code                                 |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 0                 | 100000             | 100000               | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-05-01 | 42           | 6.5          | 17                      | 745               | 100745             | 100000               | false                 |             |             |                                      |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 0                 | 100000             | 100000               | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-05-20 | 61           | 6.5          | 17                      | 1083              | 101083             | 100000               | false                 |             |             |                                      |
      | 2024-03-01 | 2024-03-20 | 19           | 0.0          | 0                       | 0                 | 300000             | 300000               | false                 | LEGISLATIVE | COVID       | Converted from new suppression style |
      | 2024-03-21 | 2024-07-06 | 108          | 6.5          | 53                      | 5754              | 305754             | 300000               | false                 |             |             |                                      |


  Scenario: Suppression, open ended suppression no payment history
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2020-04-04          | 9999-12-31        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2021-03-01        | 2021-07-06          | 1535      | 1000     | EC2M 2LS | 2021-03-06 |
    And the debt item has no payment history
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal |
      | 0                    | 0                    | 500000         | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 0                    | 0                       | 0                    | 500000           | 500000             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | amountOnIntDueWindow | unpaidAmountWindow | breathingSpaceApplied | reason      | code                                 | description |
      | 2021-03-01 | 2021-07-06 | 127          | 0.0          | 0                       | 500000               | 500000             | false                 | LEGISLATIVE | Converted from new suppression style | COVID       |


  Scenario:Suppression, open ended suppression with payment history
    Given suppression configuration data is created
      | suppressionDateFrom | suppressionDateTo | suppressionReason | suppressionReasonDesc | suppressionChargeDescription | mainTrans | subTrans | postcode | checkPeriodEnd | testRegime                                                                                              |
      | 2020-04-04          | 9999-12-31        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1535      | 1000     | EC2M 2LS | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) |
    When suppression configuration is sent to ifs service
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | postcode | periodEnd  |
      | 500000         | 2021-03-01        | 2021-07-06          | 1535      | 1000     | EC2M 2LS | 2021-03-06 |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 200000        | 2021-04-20  |
    And no breathing spaces have been applied to the debt item
    And the customer has post codes
      | postCode | postCodeDate |
      | EC2M 2LS | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | amountIntTotal | unpaidAmountTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 300000         | 300000            | 300000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 0                    | 0                       | 0                    | 300000           | 300000             | 300000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | amountOnIntDueWindow | unpaidAmountWindow | breathingSpaceApplied | reason      | code                                 | description |
      | 2021-03-01 | 2021-04-20 | 50           | 0.0          | 0                       | 200000               | 200000             | false                 | LEGISLATIVE | Converted from new suppression style | COVID       |
      | 2021-03-01 | 2021-07-06 | 127          | 0.0          | 0                       | 300000               | 300000             | false                 | LEGISLATIVE | Converted from new suppression style | COVID       |