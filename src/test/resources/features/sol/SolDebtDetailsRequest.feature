Feature: statement of liability Debt details

  Scenario: 1. TPSS Account Tax Assessment debt statement of liability, 2 duties, no payment history.
    Given debt details
      | solType | debtId  | mainTrans | subTrans |
      | UI      | debt001 | 1525      | 1000     |
    And add debt item chargeIDs to the debt
      | dutyId   |
      | "duty01" |
      | "duty02" |
    When a debt statement of liability is requested

    Then service returns debt statement of liability data
      | totalAmountIntDebt | combinedDailyAccrual |
      | 6166               | 63                   |

    And the 1st sol debt summary will contain
      | uniqueItemReference | mainTrans | description                 | periodEnd  | interestDueDebtTotal | interestRequestedTo | combinedDailyAccrual |
      | debt001             | 1525      | TPSS Account Tax Assessment | 2020-01-01 | 6166                 | 2021-05-04          | 63                   |

    And the 1st sol debt summary will contain duties
      | debtItemChargeID | subTrans | description | unpaidAmountDebt | combinedDailyAccrual |
      | duty01           | 1000     | IT          | 500000           | 35                   |
      | duty02           | 1000     | IT          | 400000           | 28                   |


  Scenario: 2. Child benefit debt statement of liability, 2 duties, with payment history.
    Given debt details
      | solType | debtId  | mainTrans | subTrans |
      | UI      | debt003 | 5330      | 7006     |
    And add debt item chargeIDs to the debt
      | dutyId   |
      | "duty01" |
      | "duty02" |
    When a debt statement of liability is requested

    Then service returns debt statement of liability data
      | totalAmountIntDebt | combinedDailyAccrual |
      | 2156               | 14                   |

    And the 1st sol debt summary will contain
      | uniqueItemReference | mainTrans | description  | periodEnd  | interestDueDebtTotal | interestRequestedTo | combinedDailyAccrual |
      | debt003             | 5330      | UI: ChB Debt | 2020-01-01 | 2156                 | 2021-05-05          | 14                   |

    And the 1st sol debt summary will contain duties
      | debtItemChargeID | subTrans | description | unpaidAmountDebt | combinedDailyAccrual |
      | duty01           | 7006     | UI: Child Benefit Debt          | 400000           | 0                   |
      | duty02           | 1000     | IT          | 200000           | 14                   |

