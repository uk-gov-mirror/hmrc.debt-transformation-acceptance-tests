
Feature: Get Debt For all the SUPPORTED REGIMES

  Scenario: Interest Bearing MainTrans (1530) debt SubTrans (1000)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1530      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 35                      | 284                  | 2.6       | 500000          | 500284            | 8            | 500000             |

  Scenario: Interest Bearing MainTrans (1535) debt SubTrans (1000)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1535      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 35                      | 284                  | 2.6       | 500000          | 500284            | 8            | 500000             |

  Scenario: Interest Bearing MainTrans (1540) debt SubTrans (1000)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1540      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 35                      | 284                  | 2.6       | 500000          | 500284            | 8            | 500000             |

  Scenario: Interest Bearing MainTrans (1545) debt SubTrans (1000)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1540      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 35                      | 284                  | 2.6       | 500000          | 500284            | 8            | 500000             |

  Scenario: Interest Bearing MainTrans (1545) debt SubTrans (1090)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1540      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 35                      | 284                  | 2.6       | 500000          | 500284            | 8            | 500000             |



  Scenario: All Non Interest Bearing MainTrans and SunTrans
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 5330      | 7006     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 5330      | 7006     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 5330      | 7011     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 5350      | 7012     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 5350      | 7014     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 5350      | 7013     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1085      | 1000     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1085      | 1020     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1085      | 1025     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1085      | 1180     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1511      | 2000     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1515      | 1090     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1520      | 1090     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1526      | 2000     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1526      | 2000     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1531      | 2000     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1536      | 2000     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1541      | 2000     | false           |
    And the debt item has no payment history
    And a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 100000         | 2021-03-01  | 2021-03-08        | 1546      | 2000     | false           |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | totalAmountIntTotal | amountOnIntDueTotal |
      | 0                    | 0                    | 1900000           | 1900000              | 1900000            |


  Scenario: MainTrans (1525) debt empty subTrans (7006)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1525      | 7006     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with Invalid combination of mainTrans and subTrans. No rule found in the configured ones
