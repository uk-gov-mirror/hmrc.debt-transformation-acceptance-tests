Feature: statement of liability Debt details

    Scenario: 1. debt statement of liability two duties.
        Given debt details
            | solType | debtType | dutyType | mainTrans | subTrans |
            | UI      | debt001  | duty01   | 1525      | 1000     |
        When a debt statement of liability is requested

        Then service returns debt statement of liability data
            | totalAmountIntDebt | combinedDailyAccrual |
            | 4820               | 46                   |

        And the 1st debt summary will contain
            | uniqueItemReference | mainTrans | description | periodEnd  | interestDueDebtTotal | interestRequestedTo | combinedDailyAccrual |
            | debt1               | 1525      | DRIER       | 2020-01-01 | 2410                 | 2021-04-29          | 23                   |

        And the 1st debt summary will contain duties
            | debtItemChargeID | subTrans | description | unpaidAmountDebt | combinedDailyAccrual |
            | duty02           | 1000     | IT          | 400000           | 28                   |
            | duty01           | 1000     | IT          | 500000           | 35                   |

        And the 2nd debt summary will contain
            | uniqueItemReference | mainTrans | description | periodEnd  | interestDueDebtTotal | interestRequestedTo | combinedDailyAccrual |
            | debt1               | 1525      | DRIER       | 2020-01-01 | 2410                 | 2021-04-29          | 23

        And the 2nd debt summary will contain duties
            | debtItemChargeID | subTrans | description | unpaidAmountDebt | combinedDailyAccrual |
            | duty02           | 1000     | IT          | 400000           | 28                   |
            | duty01           | 1000     | IT          | 500000           | 35                   |


