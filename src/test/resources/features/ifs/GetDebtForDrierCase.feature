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

Feature: Get Debt For MainTrans (1525) case (mvp)

  Scenario: Interest Bearing MainTrans (1525) debt (MVP)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 35                      | 284                  | 2.6       | 500000          | 500284            | 8            | 500000             |

  Scenario: Non Interest Bearing MainTrans (1525) debt (MVP)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1520      | 1090     | false           |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 0                       | 0                    | 0       | 500000           | 500000             | 0            | 500000             |

  Scenario: MainTrans (1525) debt Zero Amount Edge Case
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 0              | 2021-03-01  | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 0                       | 0                    | 1       | 0                | 0                  | 8            | 0                  |

# Below scenario currently fails as api returns daily interest of -0.0001. Should negative amounts be possible?
  @ignore
  Scenario: MainTrans (1525) debt Amount is negative (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | -1             | 2021-03-01  | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the 1st debt summary will contain
      | interestDueDailyAccrual | interestDueDebtTotal | intRate | unpaidAmountDebt | totalAmountIntDebt | numberOfDays | amountOnIntDueDebt |
      | 0                       | 0                    | 1       | 0                | 0                  | 8            | 0                  |

  Scenario: MainTrans (1525) debt Amount non integer (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | \"\"           | 2021-03-01  | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /originalAmount' missing or invalid

  Scenario: MainTrans (1525) debt Amount non integer (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 1.2            | 2021-03-01  | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /originalAmount' missing or invalid

  Scenario: MainTrans (1525) debt invalid entry in Date Amount (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | d           | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /dateCreated' missing or invalid

  Scenario: MainTrans (1525) debt empty entry in Date Amount (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         |             | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /dateCreated' missing or invalid

  Scenario: MainTrans (1525) debt invalid Date Amount (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-02-30  | 2021-03-08        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /dateCreated' missing or invalid

  Scenario: MainTrans (1525) debt invalid entry in dateCalculationTo (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-08  | d                 | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /dateCalculationTo' missing or invalid

  Scenario: MainTrans (1525) debt empty dateCalculationTo (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-08  |                   | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /dateCalculationTo' missing or invalid

  Scenario: MainTrans (1525) debt invalid dateCalculationTo (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-02-01  | 2021-02-30        | 1525      | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /dateCalculationTo' missing or invalid

  Scenario: MainTrans (1525) debt invalid mainTrans (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | DRIdER    | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /mainTrans' missing or invalid

  Scenario: MainTrans (1525) debt empty mainTrans (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        |           | 1000     | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /mainTrans' missing or invalid

  Scenario: MainTrans (1525) debt invalid subTrans (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1525      | invalid  | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /subTrans' missing or invalid

  Scenario: MainTrans (1525) debt empty subTrans (Edge Case)
    Given a debt item
      | originalAmount | dateCreated | dateCalculationTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2021-03-01  | 2021-03-08        | 1525      |          | true            |
    And the debt item has no payment history
    When the debt item is sent to the ifs service
    Then the ifs service will respond with /subTrans' missing or invalid
