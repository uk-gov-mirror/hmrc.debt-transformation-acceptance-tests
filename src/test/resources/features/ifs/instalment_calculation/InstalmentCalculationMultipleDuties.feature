# TODO not part of 627 ticket
# Refactor (aggregate) both instalment calculation features to use scenario outlines combined together with both interest bearing and non interest, broken down by payment frequencies


Feature: Instalment calculation for 1 debt and multiple duties with initial payment

  Scenario: Calculate quote details for 1 debt and multiple duties with non-interest bearing - weekly
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal | numberOfDay |
      | 10000                   | single           | 1                    | 1423                 | 1           |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 50000      | 5350      | 7012     |
      | debtId | 50000      | 5350      | 7013     |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns an non-interest bearing payment instalment plan

  Scenario: Calculate quote details for 1 debt and multiple duties with interest bearing - weekly
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal | numberOfDay |
      | 10000                   | single           | 1                    | 1423                 | 1           |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 50000      | 1545      | 1000     |
      | debtId | 50000      | 1545      | 1090     |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns an interest bearing payment instalment plan