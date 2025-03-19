
Feature: Sol With Suppression

  Scenario: Customer Outputs SoL where suppression is applied
    Given suppression configuration data is created
      | dateFrom            | dateTo            | reason            | reasonDesc | suppressionChargeDescription | subTrans |
      | 2021-03-04          | 2021-03-05        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1090     |
    When suppression configuration is sent to ifs service
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500177         | 35                   |
    And the 1st sol debt summary will contain
      | debtId  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 177                  | 500177             | 35                   |
    And the 1st sol debt summary will contain duties
      | subTrans | dutyTypeDescription | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | 1090     | CO: TGPEN           | 500000           | 35                   | true            | false                 |


  Scenario: Customer Outputs SoL suppression NOT applied to a different postcode
    Given suppression configuration data is created
      | dateFrom            | dateTo            | reason            | reasonDesc | suppressionChargeDescription | subTrans |
      | 2021-03-04          | 2021-03-05        | LEGISLATIVE       | COVID                 | SA-Suppression               | 999999   |
    When suppression configuration is sent to ifs service
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500249         | 35                   |
    And the 1st sol debt summary will contain
      | debtId  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 249                  | 500249             | 35                   |


  Scenario: Customer Outputs SoL where suppression is applied by Period End
    Given suppression configuration data is created
      | dateFrom            | dateTo            | reason            | reasonDesc | suppressionChargeDescription | checkPeriodEnd |
      | 2021-03-04          | 2021-03-05        | LEGISLATIVE       | COVID                 | SA-Suppression               | true           |
    When suppression configuration is sent to ifs service
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500177         | 35                   |
    And the 1st sol debt summary will contain
      | debtId  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 177                  | 500177             | 35                   |
    And the 1st sol debt summary will contain duties
      | subTrans | dutyTypeDescription | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | 1090     | CO: TGPEN           | 500000           | 35                   | true            | false                 |


  Scenario: Customer Outputs SoL where suppression is applied by Main Trans
    Given suppression configuration data is created
      | dateFrom            | dateTo            | reason            | reasonDesc | suppressionChargeDescription | mainTrans |
      | 2021-03-04          | 2021-03-05        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1545      |
    When suppression configuration is sent to ifs service
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500177         | 35                   |
    And the 1st sol debt summary will contain
      | debtId  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 177                  | 500177             | 35                   |
    And the 1st sol debt summary will contain duties
      | subTrans | dutyTypeDescription | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | 1090     | CO: TGPEN           | 500000           | 35                   | true            | false                 |


  Scenario: Customer Outputs SoL suppression NOT applied to a different mainTrans
    Given suppression configuration data is created
      | dateFrom            | dateTo            | reason            | reasonDesc | suppressionChargeDescription | mainTrans |
      | 2021-03-04          | 2021-03-05        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1540      |
    When suppression configuration is sent to ifs service
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500249         | 35                   |
    And the 1st sol debt summary will contain
      | debtId  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 249                  | 500249             | 35                   |


  Scenario: Customer Outputs SoL where suppression is applied - based on testRegime
    Given suppression configuration data is created
      | dateFrom            | dateTo            | reason            | reasonDesc | suppressionChargeDescription | testRegime                                                                                                             |
      | 2021-03-04          | 2021-03-05        | LEGISLATIVE       | COVID                 | SA-Suppression               | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) OR (1545,1090) |
    When suppression configuration is sent to ifs service
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500177         | 35                   |
    And the 1st sol debt summary will contain
      | debtId  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 177                  | 500177             | 35                   |
    And the 1st sol debt summary will contain duties
      | subTrans | dutyTypeDescription | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | 1090     | CO: TGPEN           | 500000           | 35                   | true            | false                 |


  Scenario: SoL Suppression - Applied to all criteria
    Given suppression configuration data is created
      | dateFrom            | dateTo            | reason            | reasonDesc | suppressionChargeDescription | mainTrans | subTrans | checkPeriodEnd | testRegime                                                                                                             |
      | 2021-03-04          | 2021-03-05        | LEGISLATIVE       | COVID                 | SA-Suppression               | 1545      | 1090     | true           | fake regime suppressing (MainTrans,SubTrans) = (1234,0123) OR (4567,0456) OR (7890,0789) OR (1535,1000) OR (1545,1090) |
    When suppression configuration is sent to ifs service
    And debt details
      | solType | debtId  | mainTrans | subTrans | interestRequestedTo |
      | CO      | debt008 | 1545      | 1090     | 2021-03-08          |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 500177         | 35                   |
    And the 1st sol debt summary will contain
      | debtId  | mainTrans | debtTypeDescription          | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrual |
      | debt008 | 1545      | CO: TPSS Contract Settlement | 177                  | 500177             | 35                   |
    And the 1st sol debt summary will contain duties
      | subTrans | dutyTypeDescription | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | 1090     | CO: TGPEN           | 500000           | 35                   | true            | false                 |