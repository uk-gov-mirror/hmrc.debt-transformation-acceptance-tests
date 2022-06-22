
Feature: FC VAT Debt Calculation End point testing

  Scenario: 1. Interest Indicator as Yes. 1 Payment of 1 debt.
    Given a fc vat debt item
      | debtItemChargeId  | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | debtItemChargeId1 | 500000         | 2018-12-16 | 2022-01-04          | Y                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2019-02-03  |
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 28                   | 400000            |
    And the 1st fc vat debt summary will contain
      | debtItemChargeId  | interestDueDailyAccrual | interestRate |
      | debtItemChargeId1 | 28                      | 2.6         |


  Scenario: 2. Interest Indicator as No. 1 Payment of 1 debt.
    Given a fc vat debt item
      | debtItemChargeId  | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | debtItemChargeId1 | 500000         | 2018-12-16 | 2019-04-14          | N                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2019-02-03  |
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 0                    | 400000            |
    And the 1st fc vat debt summary will contain
      | debtItemChargeId  | interestDueDailyAccrual | interestRate |
      | debtItemChargeId1 | 0                       | 0.0          |


  Scenario: 3. Interest Indicator as Yes. 2 Payment of 1 debt.
    Given a fc vat debt item
      | debtItemChargeId | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | 123              | 500000         | 2022-04-01 | 2021-11-24          | Y                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | 20000         | 2021-06-01  |
      | 20000         | 2020-07-01  |
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 32                   | 460000            |
    And the 1st fc vat debt summary will contain
      | debtItemChargeId | interestDueDailyAccrual | interestRate |
      | 123              | 32                      | 2.6          |


  Scenario: 4. Interest Indicator as Yes. 1 Payment of 1 debt. Payment amount is more than Original amount
    Given a fc vat debt item
      | debtItemChargeId | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | 123              | 500000         | 2018-12-16 | 2019-04-14          | Y                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | 1000000       | 2019-02-03  |
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service will respond with Could not parse body due to requirement failed: Total Payment amounts cannot be more than the original amount


  Scenario: 5. Interest Indicator as Yes. 1 Payment of 1 debt. Payment amount is 0
    Given a fc vat debt item
      | debtItemChargeId | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | 123              | 500000         | 2018-12-16 | 2019-04-14          | Y                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | 0             | 2019-02-03  |
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service will respond with Could not parse body due to requirement failed: Payment amount must not be zero


  Scenario: 5. Interest Indicator as Yes. 1 Payment of 1 debt. Payment amount is -10000
    Given a fc vat debt item
      | debtItemChargeId | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | 123              | 500000         | 2018-12-16 | 2019-04-14          | Y                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | -10000        | 2019-02-03  |
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service will respond with Could not parse body due to requirement failed: Payment amount must be positive


  Scenario: 6. Interest Indicator as Yes. 2 Payment of 2 debt.
    Given a fc vat debt item
      | debtItemChargeId  | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | debtItemChargeId1 | 500000         | 2022-12-16 | 2021-04-14          | Y                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2019-02-03  |
    Given a fc vat debt item
      | debtItemChargeId | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | debtItemChargeId2              | 500000         | 2022-12-16 | 2021-04-14          | Y                 |
    And the fc vat debt item has payment history
      | paymentAmount | paymentDate |
      | 100000        | 2019-02-03  |
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 56                    | 800000            |
    And the 1st fc vat debt summary will contain
      | debtItemChargeId | interestDailyAccrual | interestRate |
      | debtItemChargeId1 | 28                   | 2.6        |
    And the 2nd fc vat debt summary will contain
      | debtItemChargeId  | interestDailyAccrual | interestRate |
      | debtItemChargeId2 | 28                    | 2.6        |


  Scenario: 7. Interest Indicator as Yes. No Payment History.
    Given a fc vat debt item
      | debtItemChargeId  | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | debtItemChargeId1 | 500000         | 2022-12-16 | 2021-04-14          | Y                 |
    And the fc vat debt item has no payment history
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 35                   | 500000            |
    And the 1st fc vat debt summary will contain
      | debtItemChargeId  | interestDailyAccrual | interestRate |
      | debtItemChargeId1 | 35                   | 2.6          |


  Scenario: 8. Interest Indicator as No. No Payment History.
    Given a fc vat debt item
      | debtItemChargeId  | originalAmount | periodEnd  | interestRequestedTo | interestIndicator |
      | debtItemChargeId1 | 500000         | 2022-12-16 | 2021-04-14          | N                 |
    And the fc vat debt item has no payment history
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service wilL return a total debts summary of
      | combinedDailyAccrual | unpaidAmountTotal |
      | 0                    | 500000            |
    And the 1st fc vat debt summary will contain
      | debtItemChargeId  | interestDailyAccrual | interestRate |
      | debtItemChargeId1 | 0                    | 0.0          |


  Scenario: 9. periodEnd missing. Interest Indicator as No. No Payment History.
    Given a fc vat debt item
      | debtItemChargeId  | originalAmount | periodEnd | interestRequestedTo | interestIndicator |
      | debtItemChargeId1 | 500000         |           | 2021-04-14          | N                 |
    And the fc vat debt item has no payment history
    And no breathing spaces have been applied to the fc vat customer
    When the debt item is sent to the fc vat ifs service
    Then the fc vat ifs service will respond with Field at path '/debtItems(0)/periodEnd' missing or invalid