@runMe
Feature: Get Debt For all the SUPPORTED REGIMES

  Scenario Outline: Interest Bearing TPSS MainTrans SubTrans
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans   | subTrans   |
      | 500000         | 2021-03-01        | 2021-03-08          | <mainTrans> | <subTrans> |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator |
      | true            | 35                      | 249                  | 2.6     | 500000           | 500249             | 7                    | 500000             | false                 |
    Examples:
      | mainTrans | subTrans |
      | 1525      | 1000     |
      | 1530      | 1000     |
      | 1535      | 1000     |
      | 1540      | 1000     |
      | 1545      | 1000     |
      | 1545      | 1090     |
      | 1545      | 2000     |

  Scenario Outline: Non Interest Bearing TPSS MainTrans and SubTrans
    Given the current set of rules
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans   | subTrans   |
      | 500000         | 2021-03-01        | 2021-03-08          | <mainTrans> | <subTrans> |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator   |
      | false           | 0                       | 0                    | 0       | 500000           | 500000             | 0                    | 500000             | <interestOnlyIndicator> |
    Examples:
      | mainTrans | subTrans | interestOnlyIndicator |
      | 5330      | 7006     | false                 |
      | 5330      | 7010     | false                 |
      | 5330      | 7011     | false                 |
      | 5350      | 7012     | false                 |
      | 5350      | 7014     | false                 |
      | 5350      | 7013     | false                 |
      | 1085      | 1000     | false                 |
      | 1085      | 1020     | false                 |
      | 1085      | 1025     | false                 |
      | 1085      | 1180     | false                 |
      | 1511      | 2000     | true                  |
      | 1515      | 1090     | false                 |
      | 1520      | 1090     | false                 |
      | 1526      | 2000     | true                  |
      | 1531      | 2000     | true                  |
      | 1536      | 2000     | true                  |
      | 1541      | 2000     | true                  |
      | 1546      | 2000     | true                  |
      | 2421      | 1150     | false                 |
      | 1441      | 1150     | false                 |

  Scenario: MainTrans (1525) debt empty subTrans (7006)
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2021-03-01        | 2021-03-08          | 1525      | 7006     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service will respond with Invalid combination of mainTrans and subTrans. No rule found in the configured ones

  Scenario Outline: Interest Bearing Employer PAYE charges
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans   | subTrans   |
      | 500000         | 2021-03-01        | 2021-03-08          | <mainTrans> | <subTrans> |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | totalAmountIntDuty | interestOnlyIndicator   |
      | true            | 35                      | 500249             | <interestOnlyIndicator> |
    Examples:
      | mainTrans | subTrans | interestOnlyIndicator |
      | 2000      | 1000     | false                 |
      | 2000      | 1020     | false                 |
      | 2000      | 1023     | false                 |
      | 2000      | 1026     | false                 |
      | 2000      | 1030     | false                 |
      | 2000      | 1100     | false                 |
      | 2006      | 1106     | false                 |
      | 2030      | 1250     | false                 |
      | 2030      | 1260     | false                 |
      | 2030      | 1270     | false                 |
      | 2030      | 1280     | false                 |
      | 2030      | 1290     | false                 |
      | 2030      | 1300     | false                 |
      | 2030      | 1310     | false                 |
      | 2030      | 1320     | false                 |
      | 2030      | 1330     | false                 |
      | 2030      | 1340     | false                 |
      | 2030      | 1350     | false                 |
      | 2030      | 1390     | false                 |
      | 2030      | 1395     | false                 |
      | 2040      | 1000     | false                 |
      | 2060      | 1020     | false                 |
      | 2090      | 1000     | false                 |
      | 2090      | 1020     | false                 |
      | 2090      | 1023     | false                 |
      | 2090      | 1026     | false                 |
      | 2090      | 1100     | false                 |
      | 2090      | 1250     | false                 |
      | 2090      | 1260     | false                 |
      | 2090      | 1270     | false                 |
      | 2090      | 1280     | false                 |
      | 2090      | 1290     | false                 |
      | 2090      | 1300     | false                 |
      | 2090      | 1310     | false                 |
      | 2090      | 1320     | false                 |
      | 2090      | 1330     | false                 |
      | 2090      | 1340     | false                 |
      | 2090      | 1350     | false                 |
      | 2100      | 1000     | false                 |
      | 2100      | 1023     | false                 |
      | 2100      | 1026     | false                 |
      | 2100      | 1030     | false                 |
      | 2100      | 1100     | false                 |
      | 2130      | 1355     | false                 |

  Scenario Outline: Non Interest Bearing Employer PAYE MainTrans and SubTrans
    Given the current set of rules
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans   | subTrans   |
      | 500000         | 2021-03-01        | 2021-03-08          | <mainTrans> | <subTrans> |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestBearing | interestDueDailyAccrual | interestDueDutyTotal | intRate | unpaidAmountDuty | totalAmountIntDuty | numberChargeableDays | amountOnIntDueDuty | interestOnlyIndicator   |
      | false           | 0                       | 0                    | 0       | 500000           | 500000             | 0                    | 500000             | <interestOnlyIndicator> |
    Examples:
      | mainTrans | subTrans | interestOnlyIndicator |
      | 2005      | 2000     | true                  |
      | 2005      | 2020     | true                  |
      | 2005      | 2023     | true                  |
      | 2005      | 2026     | true                  |
      | 2005      | 2030     | true                  |
      | 2005      | 2100     | true                  |
      | 2007      | 1107     | true                  |
      | 2045      | 2000     | true                  |
      | 2045      | 2100     | true                  |
      | 2065      | 2020     | true                  |
      | 2095      | 2000     | true                  |
      | 2095      | 2020     | true                  |
      | 2095      | 2023     | true                  |
      | 2095      | 2026     | true                  |
      | 2095      | 2100     | true                  |
      | 2105      | 2000     | true                  |
      | 2105      | 2023     | true                  |
      | 2105      | 2026     | true                  |
      | 2105      | 2030     | true                  |
      | 2105      | 2100     | true                  |
      | 2135      | 2355     | true                  |

