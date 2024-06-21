###Debt 1. 2 duties. Interest bearing with no Payment history

#Debt 1 Duty 1 originalAmount= 500,000
#Debt 1 Duty 1 interestStartDate = 20/12/2020
#Debt 1 Duty 1 interestRequestedTo = 10/08/2021
#Debt 1 Duty 1 With Breathing spaces

#Debt 1 Duty 2 originalAmount= 400,000
#Debt 1 Duty 2 interestStartDate = 04/02/2021
#Debt 1 Duty 2 interestRequestedTo = 10/08/2021
#Debt 1 Duty 2 With Breathing spaces


###Debt 2. 1 duty, Non-interest bearing with Payment history

#Debt 2 Duty 1 originalAmount= 100,000
#Debt 2 Duty 1 With Breathing spaces

Feature: statement of liability multiple debts
  
  Scenario: 1. TPSS Account Tax Assessment debt statement of liability, 2 debts with breathing spaces
    Given statement of liability multiple debt requests
      | solType | solRequestedDate | debtId  | debtId2 | interestRequestedTo |
      | UI      | 2021-05-13       | debt001 | debt004 | 2021-08-10          |
    And add debt item chargeIDs to the debt
      | dutyId |
      | duty01 |
      | duty02 |
    When a debt statement of liability is requested
    Then service returns debt statement of liability data
      | amountIntTotal | combinedDailyAccrual |
      | 1107817        | 63                   |
    And the 1st multiple statement of liability debt summary will contain duties
      | debtId  | mainTrans | debtTypeDescription         | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrualDebt | dutyId | subTrans | dutyTypeDescription | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | debt001 | 1525      | TPSS Account Tax Assessment | 7817                 | 907817             | 63                       | duty01 | 1000     | IT                  | 500000           | 35                   | true            | false                 |
    And the statement of liability debt summary response
      | debtId  | mainTrans | debtTypeDescription   | interestDueDebtTotal | totalAmountIntDebt | combinedDailyAccrualDebt | dutyId | subTrans | dutyTypeDescription             | unpaidAmountDuty | combinedDailyAccrual | interestBearing | interestOnlyIndicator |
      | debt004 | 5350      | UI: ChB Migrated Debt | 0                    | 200000             | 0                        | duty04 | 7012     | UI: Child Benefit Migrated Debt | 200000           | 0                    | false           | false                 |