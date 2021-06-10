Feature: Suppression - Edge cases

  Scenario: Suppression, interest rate change during suppression
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2020-04-04 | 2020-05-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2020-04-01        | 2020-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason |
      | 2020-04-01 | 2020-04-03 | 2            | 2.75         | 500000               |        |
      | 2020-04-04 | 2020-05-04 | 31           | 0.0          | 500000               | POLICY |
      | 2020-05-05 | 2020-07-06 | 63           | 2.6          | 500000               |        |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 65                   |

  #TODO Fails Incorrect int rate when interest rate changes after suppression
  @wip @DTD-377
  Scenario: Suppression, interest rate change after suppression ends
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2020-04-02 | 2020-04-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2020-04-01        | 2020-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason |
      | 2020-04-01 | 2020-04-03 | 2            | 2.75         | 500000               |        |
      | 2020-04-04 | 2020-05-04 | 31           | 0.0          | 500000               | POLICY |
      | 2020-05-05 | 2020-07-06 | 63           | 2.75         | 500000               |        |
      | 2020-05-05 | 2020-07-06 | 63           | 2.6          | 500000               |        |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 65                   |

  Scenario: Suppression, interest rate change before suppression
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2020-04-02 | 2020-04-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2020-03-01        | 2020-04-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason |
      | 2020-03-01 | 2020-03-29 | 28           | 3.25         | 500000               |        |
      | 2020-03-30 | 2020-04-01 | 3            | 2.75         | 500000               |        |
      | 2020-04-02 | 2020-04-04 | 3            | 0.0          | 500000               | POLICY |
      | 2020-04-05 | 2020-04-06 | 2            | 2.75         | 500000               |        |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 37                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 33                   |

  #TODO Fails Incorrect int rate when interest rate changes after suppression
  @wip @DTD-377
  Scenario: Suppression, interest rate change before and after suppression
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2020-04-02 | 2020-04-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2020-03-01        | 2020-04-30          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason |
      | 2020-03-01 | 2020-03-29 | 28           | 3.25         | 500000               |        |
      | 2020-03-30 | 2020-04-01 | 3            | 2.75         | 500000               |        |
      | 2020-04-02 | 2020-04-04 | 3            | 0.0          | 500000               | POLICY |
      | 2020-04-05 | 2020-04-06 | 2            | 2.75         | 500000               |        |
      | 2020-04-07 | 2020-04-20 | 187          | 2.6          | 500000               |        |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 124                  |

  # TODO Fails 2 overlapping suppressions that start on same day returns incorrect interest rate in calc window
  @wip @DTD-366
  Scenario: Suppression, 1 duty, 2 overlapping suppressions that start on same day
    Given suppression data has been created
      | reason      | enabled | fromDate   | toDate     |
      | LEGISLATIVE | true    | 2021-04-04 | 2021-05-04 |
      | LEGISLATIVE | true    | 2021-04-04 | 2021-05-20 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2021-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason      |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 500000               |             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 500000               | LEGISLATIVE |
      | 2021-05-05 | 2021-05-20 | 16           | 0.0          | 500000               | LEGISLATIVE |
      | 2021-05-21 | 2021-07-06 | 47           | 2.6          | 500000               |             |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 108                  |

  Scenario: Suppression, 1 duty, 2 overlapping suppressions
    Given suppression data has been created
      | reason      | enabled | fromDate   | toDate     |
      | LEGISLATIVE | true    | 2021-04-04 | 2021-05-04 |
      | LEGISLATIVE | true    | 2021-04-05 | 2021-05-20 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2021-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason      |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 500000               |             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 500000               | LEGISLATIVE |
      | 2021-05-05 | 2021-05-20 | 16           | 0.0          | 500000               | LEGISLATIVE |
      | 2021-05-21 | 2021-07-06 | 47           | 2.6          | 500000               |             |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 108                  |

# TODO Fails. IFS returns 400 when suppression starts before interest start date
  @DTD-371 @wip
  Scenario: Suppression period starts before interest start date
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2021-01-31 | 2021-05-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal |
      | 35                   | 2243                 |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 155                  | 35                      | 502243             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual |
      | 2021-02-01 | 2021-05-04 | 93           | 0.0          | 0                       |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      |

# TODO Fails. Calc window error when suppression period starts on same day as interest start date
#  An additional calc window is created with a value of -1 days
  @DTD-380 @wip
  Scenario: Suppression period starts on same day as interest start date
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2021-02-01 | 2021-05-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal |
      | 35                   | 2243                 |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 155                  | 35                      | 502243             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual |
      | 2021-02-01 | 2021-05-04 | 93           | 0.0          | 0                       |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      |

  Scenario: Suppression on non interest bearing debt
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2021-01-04 | 2021-05-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2021-02-01        | 2021-07-06          | 1520      | 1090     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW2 4TW  | 2018-07-06   |
      | TW3 4QQ  | 2019-07-06   |
      | TW43 4QR | 2020-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal |
      | 0                    | 0                    |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 0                    | 0                       | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual |
      | 2021-02-01 | 2021-07-06 | 0            | 0.0          | 0                       |
