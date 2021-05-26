#*Assumptions*
#* originalAmount = 500,000
#* dateCreated = 01/01/2020
#* mainTrans = 1535
#* subTrans = 1000
#* interestStartDate = 01/02/2021
#
#* interestBearing = True
#* interestRate = 2.6%
#* No changes to interest rates
#
#* Interest requested to 6/7/2021
#* No repayments
#* No breathing space is applied
#* mainTrans, subTrans, addressPostcode and period end are mandatory fields
#* Suppression is on mainTrans 1535 and subTrans 1000
#* suppressionDateFrom = 04/04/2021
#* suppressionDateTo = 04/05/2021

#Supression scenario edge cases to add
#Scenario: Suppression, interest rate change before suppression
#Scenario: Suppression, interest rate change after suppression
#Scenario: Suppression, 2 interest rate changes during suppression
#Scenario: Suppression, payment before suppression
#Scenario: Suppression, payment after suppression
#Scenario: Suppression, breathing space with suppression

Feature: Suppression

  Scenario: Suppression applied to sub trans
    Given suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2021-04-04 | 2021-05-04 |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2021-02-01        | 2021-02-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 4415                 | 500000            | 504415         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 124                  | 35                      | 4415                 | 500000           | 504415             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | suppressionApplied | suppressionReasonDesc | suppressionReasonDesc |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 35                      | 502172             | false              |                       |                       |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 500000             | true               | tbc                   | tbc                   |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      | 502243             | false              |                       |                       |

  Scenario: Suppression, 2 payments on same day during suppression
    Given suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2021-04-04 | 2021-05-04 |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2021-04-20  |
      | 50000         | 2021-04-20  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | amountIntTotal |
      | 24                   | 353741         |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 185                  | 35                      | 353741             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | suppressionApplied | suppressionReasonDesc | suppressionReasonDesc |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 10                      | 150651             | false              |                       |                       |
      | 2021-04-04 | 2021-04-20 | 17           | 0.0          | 0                       | 150000             | true               | tbc                   | tbc                   |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 24                      | 351520             | false              |                       |                       |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 350000             | true               | tbc                   | tbc                   |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 24                      | 351570             | false              |                       |                       |

  Scenario: Suppression, 2 duties, 2 payments on same day for one of the duties
    Given suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2021-04-04 | 2021-05-04 |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 400000         | 2020-01-01  | 2021-02-01        | 2021-04-03          | 1535      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2021-02-20  |
      | 50000         | 2021-02-20  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 100000         | 2020-01-01  | 2021-02-01        | 2021-04-03          | 1535      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2021-02-20  |
      | 50000         | 2021-02-20  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | suppressionApplied | suppressionReasonDesc |
      | 2021-02-01 | 2021-02-20 | 19           | 2.6          | 150000               |                    |                       |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 250000               |                    |                       |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 250000               | true               |                       |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 250000               |                    |                       |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 20                   | 300000            |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | unpaidAmountDuty |
      | 174                  | 17                      | 500000           |
    Then the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | suppressionApplied | suppressionReasonDesc |
      | 2021-02-01 | 2021-02-20 | 19           | 2.6          | 50000                |                    |                       |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 50000                |                    |                       |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 50000                | true               |                       |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 50000                |                    |                       |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 3                    | 50000             |
    And the 1st debt summary will contain
      | numberChargeableDays | unpaidAmountDuty |
      | 174                  | 500000           |

  Scenario: Suppression, interest rate change during suppression
    Given suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2020-04-04 | 2020-05-04 |
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2020-04-01        | 2020-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | suppressionApplied | suppressionReasonDesc |
      | 2020-04-01 | 2020-04-03 | 2            | 2.75         | 500000               |                    |                       |
      | 2020-04-04 | 2020-05-04 | 31           | 0.0          | 500000               | true               | tbc                   |
      | 2020-05-05 | 2020-07-06 | 63           | 2.6          | 500000               |                    |                       |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 96                   |

  Scenario: Suppression, 1 duty, 2 overlapping suppressions
    Given suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2021-04-04 | 2021-05-04 |
    And suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2021-04-04 | 2021-05-20 |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2021-01-01  | 2021-02-01        | 2021-04-03          | 1535      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2021-04-20  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | suppressionApplied | suppressionReasonDesc |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 500000               |                    |                       |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 500000               | true               | tbc                   |
      | 2021-05-05 | 2021-05-20 | 16           | 0.0          | 500000               | true               | tbc                   |
      | 2021-05-21 | 2021-07-06 | 47           | 2.6          | 500000               |                    |                       |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 155                  |

  Scenario: Suppression, open ended suppression
    Given suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2021-04-04 | 2021-05-04 |
    And suppression data has been created
      | reason      | isActive | fromDate   | toDate     |
      | LEGISLATIVE | true     | 2021-04-04 | 2021-05-20 |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2021-01-01  | 2021-02-01        | 2021-04-03          | 1535      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2021-04-20  |
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | suppressionApplied | suppressionReasonDesc |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 500000               |                    |                       |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 500000               | true               | tbc                   |
      | 2021-05-05 | 2021-05-20 | 16           | 0.0          | 500000               | true               | tbc                   |
      | 2021-05-21 | 2021-07-06 | 47           | 2.6          | 500000               |                    |                       |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 155                  |
