Feature: statement of liability Debt details

  @wip2
  Scenario: 1. debt statement of liability two duties.
    Given debt details
      | solType | debtType | dutyType | mainTrans | subTrans |
      | UI      | debt001  | duty01   | 1525      | 1000     |
    When a debt statement of liability is requested

    Then service returns debt statement of liability data
      | combinedDailyAccrual | periodEnd  | interestDueDebtTotal | interestRequestedTo | description                    |
      | 63                   | 2020-01-01 | 6166                 | 2021-05-04          | TPSS Account Tax Assessmen0000 |

    And the duty summary will contain
      | debtItemChargeID | description | unpaidAmountDebt | combinedDailyAccrual |
      | duty02           | IT          | 400000           | 28                   |
      | duty01           | IT          | 500000           | 35                   |


