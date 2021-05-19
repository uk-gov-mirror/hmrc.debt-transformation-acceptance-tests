*Assumptions*
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

Feature: Supression

  Scenario: Suppression applied to sub trans
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2021-02-01        | 2021-02-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 3329                 | 500000            | 503329         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 124                  | 35                      | 3329                 | 500000           | 503329             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | interestDueWindow | amountOnIntDueWindow | unpaidAmountWindow |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 35                      | 1086              | 500000               | 501086             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 0                 | 500000               | 500000             |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      | 2243              | 500000               | 502243             |
