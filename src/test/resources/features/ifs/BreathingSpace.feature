#  Assumptions
#  NO suppression period

# DTD-185. Breathing Space

# Scenario 1. Breathing Space applied to 1 debt
# Scenario 2. Breathing Space - open ended

#  Scenarios TBC and will be added below
# Breathing space applied to more than 1 debt
# Breathing space applied where payments are made
# More than one breathing space not overlapping
# Payments being made or interest rate change while breathing space is applied
@runMe
Feature: Breathing Space

  @wip @DTD-2244 @DTD-2273 @DTD-2274
  Scenario: Interest Bearing. Single debt with breathing space and no payment history
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 500000         | 2018-12-16        | 2019-04-14          | 1525      | 1000     | true            |
    And the debt item has no payment history
    And the debt item has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2019-01-03      | 2019-02-03    |
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal |
      | 44                   | 3872                 | 500000            |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty |
      | true            | 87                   | 44                      | 3872                 | 500000           |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied |
      | 2018-12-16 | 2019-01-02 | 17           | 3.25         | 44                      | 500756             | false                 |
      | 2019-01-03 | 2019-02-03 | 31           | 0.0          | 0                       | 500000             | true                  |
      | 2019-02-04 | 2019-04-14 | 70           | 3.25         | 44                      | 503116             | false                 |

  @wip @DTD-2244
  Scenario: 2 debts with breathing space. No payment history (Scenario 1 - step 6)
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 50000          | 2022-01-31        | 2022-05-15          | 1525      | 1000     | true            |
    And the debt item has no payment history
    And the debt item has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2022-03-01      | 2022-04-29    |
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 50000          | 2022-01-31        | 2022-05-15          | 1525      | 1000     | true            |
    And the debt item has no payment history
    And the debt item has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2022-03-01      | 2022-04-29    |
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | amountIntTotal |
      | 8                    | 100364         |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 44                   | 4                       | 50182              |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied |
      | 2022-01-31 | 2022-02-20 | 20           | 2.75         | 3                       | 50075              | false                 |
      | 2022-02-21 | 2022-02-28 | 8            | 3.0          | 4                       | 50032              | false                 |
      | 2022-03-01 | 2022-04-05 | 35           | 0.0          | 0                       | 50000              | true                  |
      | 2022-04-05 | 2022-04-29 | 25           | 0.0          | 0                       | 50000              | true                  |
      | 2022-04-30 | 2022-05-15 | 16           | 3.25         | 4                       | 50071              | false                 |
    And the 2nd debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 44                   | 4                       | 50182              |
    And the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied |
      | 2022-01-31 | 2022-02-20 | 20           | 2.75         | 3                       | 50075              | false                 |
      | 2022-02-21 | 2022-02-28 | 8            | 3.0          | 4                       | 50032              | false                 |
      | 2022-03-01 | 2022-04-04 | 35           | 0.0          | 0                       | 50000              | true                  |
      | 2022-04-05 | 2022-04-29 | 25           | 0.0          | 0                       | 50000              | true                  |
      | 2022-04-30 | 2022-05-15 | 16           | 3.25         | 4                       | 50071              | false                 |

  @wip @DTD-2140 @DTD-2243
  Scenario: Single debt with breathing space AND payment history
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 50000          | 2022-04-06        | 2022-04-29          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 20000         | 2022-04-24  |
    And the debt item has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2022-04-10      | 2022-04-20    |
    And no breathing spaces have been applied to the debt item
    And the debt item has no payment history
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | amountIntTotal |
      | 4                    | 30042          |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 16                   | 4                       | 30042              |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied |
      | 2022-04-06 | 2022-04-09 | 3            | 3.25         | 4                       | 50013              | false                 |
      | 2022-04-10 | 2022-04-20 | 10           | 0.0          | 0                       | 50000              | true                  |
      | 2022-04-21 | 2022-04-24 | 4            | 3.25         | 1                       | 20005              | false                 |
      | 2022-04-21 | 2022-04-29 | 9            | 3.25         | 4                       | 30024              | false                 |

  @wip @DTD-2140 @DTD-2243
  Scenario: 2 debts one with a breathing space and payment history plus a late payment debt (Scenario 1, Step 7)
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 50000          | 2022-01-31        | 2022-06-10          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 25000         | 2022-05-30  |
    And the debt item has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2022-03-01      | 2022-04-29    |
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 1500           | 2034-11-12        | 2022-06-10          | 1520      | 1090     | false           |
    And no breathing spaces have been applied to the debt item
    And the debt item has no payment history
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | amountIntTotal |
      | 2                    | 27401          |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 70                   | 2                       | 50274              |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | breathingSpaceApplied |
      | 2022-01-31 | 2022-02-20 | 20           | 2.75         | 3                       | 50075              | false                 |
      | 2022-02-21 | 2022-02-28 | 8            | 3.0          | 4                       | 50032              | false                 |
      | 2022-03-01 | 2022-04-04 | 35           | 0.0          | 0                       | 50000              | true                  |
      | 2022-04-05 | 2022-04-29 | 25           | 0.0          | 0                       | 50000              | true                  |
      | 2022-04-30 | 2022-05-23 | 24           | 3.25         | 4                       | 50106              | false                 |
      | 2022-05-24 | 2022-05-30 | 7            | 3.5          | 4                       | 50033              | false                 |
      | 2022-05-31 | 2022-06-10 | 11           | 3.5          | 2                       | 25026              | false                 |
    And the 2nd debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 130                  | 0                       | 15000              |

  @wip @DTD-2140 @DTD-2243
  Scenario: 1 debt with a payment and 2 breathing spaces (incl an open ended BS), 1 late payment debt, 3rd debt with BS (Scenario 2, Step 4)
    Given a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 50000          | 2022-01-31        | 2022-06-17          | 1525      | 1000     | true            |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 25000         | 2022-05-30  |
    And the debt item has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2022-03-01      | 2022-04-29    |
      | 2023-04-01      | 2023-06-17    |
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 1500           | 2034-11-12        | 2022-06-10          | 1520      | 1090     | false           |
    And no breathing spaces have been applied to the debt item
    And the debt item has no payment history
    And a debt item
      | originalAmount | interestStartDate | interestRequestedTo | mainTrans | subTrans | interestBearing |
      | 50000          | 2022-07-30        | 2023-06-17          | 1525      | 1000     | true            |
    And the debt item has breathing spaces applied
      | debtRespiteFrom | debtRespiteTo |
      | 2023-04-01      | 2023-06-17    |
    And the debt item has no payment history
    And no post codes have been provided for the customer
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | amountIntTotal |
      | 2                    | 27402          |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 59                   | 0                       | 50246              |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow |
      | 2022-01-31 | 2022-02-20 | 20           | 2.75         | 3                       | 50075              |
      | 2022-02-21 | 2022-02-28 | 8            | 3.0          | 4                       | 50032              |
      | 2022-03-01 | 2022-04-04 | 35           | 0.0          | 0                       | 50000              |
      | 2022-04-05 | 2022-04-29 | 25           | 0.0          | 0                       | 50000              |
      | 2022-04-30 | 2022-05-23 | 24           | 3.25         | 4                       | 50106              |
      | 2022-05-24 | 2022-05-30 | 7            | 3.50         | 4                       | 50033              |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 130                  | 2                       | 50274              |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow |
      | 2022-01-31 | 2022-02-20 | 20           | 2.75         | 3                       | 50075              |
      | 2022-02-21 | 2022-02-28 | 8            | 3.0          | 4                       | 50032              |
      | 2022-03-01 | 2022-04-04 | 35           | 0.0          | 0                       | 50000              |
      | 2022-04-05 | 2022-04-29 | 25           | 0.0          | 0                       | 50000              |
      | 2022-04-30 | 2022-05-23 | 24           | 3.25         | 4                       | 50106              |
      | 2022-05-24 | 2022-05-30 | 7            | 3.50         | 4                       | 50033              |
      | 2022-05-31 | 2022-07-04 | 35           | 3.50         | 2                       | 50083              |
      | 2022-07-05 | 2022-08-22 | 49           | 3.75         | 2                       | 50125              |
      | 2022-08-23 | 2022-10-10 | 49           | 4.25         | 2                       | 50142              |
      | 2022-10-11 | 2022-11-21 | 49           | 4.75         | 2                       | 50136              |
      | 2022-11-11 | 2023-02-20 | 91           | 5.50         | 2                       | 50342              |
      | 2023-02-21 | 2023-03-31 | 39           | 6.50         | 2                       | 50173              |
      | 2023-04-01 | 2023-04-12 | 12           | 0.0          | 0                       | 50000              |
      | 2023-04-13 | 2023-06-17 | 66           | 0.0          | 0                       | 50000              |
    And the 2nd debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 130                  | 0                       | 15000              |
    And the 3rd debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 244                  | 0                       | 50274              |
    And the 3rd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow |
      | 2022-07-30 | 2022-08-22 | 23           | 3.75         | 2                       | 50125              |
      | 2022-08-23 | 2022-10-10 | 49           | 4.25         | 2                       | 50142              |
      | 2022-10-11 | 2022-11-21 | 42           | 4.75         | 2                       | 50136              |
      | 2022-11-11 | 2023-02-20 | 91           | 5.50         | 2                       | 50342              |
      | 2023-02-21 | 2023-03-31 | 39           | 6.50         | 2                       | 50173              |
      | 2023-04-01 | 2023-04-12 | 12           | 0.0          | 0                       | 50000              |
      | 2023-04-13 | 2023-06-17 | 66           | 0.0          | 0                       | 50000              |
