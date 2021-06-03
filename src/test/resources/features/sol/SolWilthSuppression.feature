Feature: Sol With Suppression

  Scenario: 1. Customer Outputs SoL where suppression is applied
    Given suppression data has been created
      | reason      | enabled | fromDate   | toDate     |
      | LEGISLATIVE | true    | 2021-03-04 | 2021-03-05 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW33     | 1              |
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo | solRequestedDate |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          | 2021-03-08       |
    And add debt item chargeIDs to the debt
      | dutyId   |
      | "duty01" |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500177         | 35                   |
    And the 1st sol debt summary will contain
      | debtID  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 177                  | 500177             | 35                   |
    And the 1st sol debt summary will contain duties
      | dutyID | subTrans | dutyTypeDescription | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | duty01 | 1090     | CO: TGPEN           | 500000           | 35                   | true            | false                 |

  Scenario: 1. Customer Outputs SoL where suppression is applied to a different postcode
    Given suppression data has been created
      | reason      | enabled | fromDate   | toDate     |
      | LEGISLATIVE | true    | 2021-03-04 | 2021-03-05 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW34     | 1              |
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo | solRequestedDate |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          | 2021-03-08       |
    And add debt item chargeIDs to the debt
      | dutyId   |
      | "duty01" |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500249         | 35                   |
    And the 1st sol debt summary will contain
      | debtID  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 249                  | 500249             | 35                   |

