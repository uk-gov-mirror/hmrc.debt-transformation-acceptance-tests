#*Assumptions*

#* mainTrans = 1535
#* subTrans = 1000
#* interestBearing = True
#* Suppression is on mainTrans 1535 and subTrans 1000

#BELOW Suppression scenario edge cases can be added as part of DTD-299?

#Suppression added to postcode
#Scenario: Suppression, interest rate change before suppression
#Scenario: Suppression, interest rate change after suppression
#Scenario: Suppression, 2 interest rate changes during suppression
#Scenario: Suppression, payment before suppression
#Scenario: Suppression, payment after suppression
#Scenario: Suppression, breathing space with suppression

#BELOW SCENARIOS cover ac in DTD-157 and DTD-299

Feature: Suppression


  Scenario: Suppression applied to sub trans
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2021-04-04 | 2021-05-04 |
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
      | combinedDailyAccrual | interestDueCallTotal | unpaidAmountTotal | amountIntTotal | amountOnIntDueTotal |
      | 35                   | 4415                 | 500000            | 504415         | 500000              |
    And the 1st debt summary will contain
      | interestBearing | numberChargeableDays | interestDueDailyAccrual | interestDueDutyTotal | unpaidAmountDuty | totalAmountIntDuty | amountOnIntDueDuty |
      | true            | 124                  | 35                      | 4415                 | 500000           | 504415             | 500000             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | reason | code |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 35                      | 502172             |        |      |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 500000             | POLICY | 1    |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 35                      | 502243             |        |      |

  Scenario: Suppression, 2 payments on same day during suppression
    Given suppression data has been created
      | reason      | enabled | fromDate   | toDate     |
      | LEGISLATIVE | true    | 2021-04-04 | 2021-05-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 500000         | 2020-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2021-04-20  |
      | 50000         | 2021-04-20  |
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | amountIntTotal |
      | 24                   | 353741         |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 185                  | 24                      | 353741             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual | unpaidAmountWindow | reason      | code |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 10                      | 150651             |             |      |
      | 2021-04-04 | 2021-04-20 | 17           | 0.0          | 0                       | 150000             | LEGISLATIVE | 1    |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 24                      | 351520             |             |      |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 0                       | 350000             | LEGISLATIVE | 1    |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 24                      | 351570             |             |      |

  Scenario: Suppression, 2 duties, 2 payments on same day for one of the duties
    Given suppression data has been created
      | reason      | enabled | fromDate   | toDate     |
      | LEGISLATIVE | true    | 2021-04-04 | 2021-05-04 |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 1              |
    And a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 400000         | 2020-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2021-02-20  |
      | 50000         | 2021-02-20  |
    Given a debt item
      | originalAmount | dateCreated | interestStartDate | interestRequestedTo | mainTrans | subTrans |
      | 400000         | 2020-01-01  | 2021-02-01        | 2021-07-06          | 1535      | 1000     |
    And the debt item has no payment history
    And no breathing spaces have been applied to the customer
    And the customer has post codes
      | postCode | postCodeDate |
      | TW3 4QQ  | 2019-07-06   |
    When the debt item is sent to the ifs service
    Then the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason      |
      | 2021-02-01 | 2021-02-20 | 19           | 2.6          | 150000               |             |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 250000               |             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 250000               | LEGISLATIVE |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 250000               |             |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 45                   | 650000            |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | unpaidAmountDuty |
      | 143                  | 17                      | 250000           |
    Then the 2nd debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason      |
      | 2021-02-01 | 2021-04-03 | 61           | 2.6          | 400000               |             |
      | 2021-04-04 | 2021-05-04 | 31           | 0.0          | 400000               | LEGISLATIVE |
      | 2021-05-05 | 2021-07-06 | 63           | 2.6          | 400000               |             |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 45                   | 650000            |
    And the 2nd debt summary will contain
      | numberChargeableDays | unpaidAmountDuty |
      | 124                  | 400000           |

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

  #Fails Incorrect int rate when interest rate changes after suppression
  @wip @DTD-377
  Scenario: Suppression, interest rate change after suppression
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

  #Fails Incorrect int rate when interest rate changes after suppression
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

  #Fails 2 overlapping suppressions that start on same day returns incorrect interest rate in calc window
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

  Scenario: Suppression, open ended suppression
    Given suppression data has been created
      | reason      | enabled | fromDate   | toDate     |
      | LEGISLATIVE | true    | 2020-04-04 | 9999-12-31 |
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
      | periodFrom | periodTo   | numberOfDays | interestRate | amountOnIntDueWindow | reason      |
      | 2020-04-01 | 2020-04-03 | 2            | 2.75         | 500000               |             |
      | 2020-04-04 | 2020-07-06 | 94           | 0.0          | 500000               | LEGISLATIVE |
    And the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 0                    | 500000            |
    And the 1st debt summary will contain
      | numberChargeableDays |
      | 2                    |

  Scenario: Suppression not applied to customers previous postcode
    Given suppression data has been created
      | reason | enabled | fromDate   | toDate     |
      | POLICY | true    | 2021-01-04 | 2021-05-04 |
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
      | TW2 4TW  | 2018-07-06   |
      | TW3 4QQ  | 2019-07-06   |
      | TW43 4QR | 2020-07-06   |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a total debts summary of
      | combinedDailyAccrual | interestDueCallTotal |
      | 35                   | 5520                 |
    And the 1st debt summary will contain
      | numberChargeableDays | interestDueDailyAccrual | totalAmountIntDuty |
      | 155                  | 35                      | 505520             |
    And the 1st debt summary will have calculation windows
      | periodFrom | periodTo   | numberOfDays | interestRate | interestDueDailyAccrual |
      | 2021-02-01 | 2021-07-06 | 155          | 2.6          | 35                      |
