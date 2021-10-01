Feature: Instalment calculation for 1 debt and multiple duties with initial payment

  @627
  Scenario: Calculate quote details for 1 debt and multiple duties with interest bearing - weekly
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal | numberOfDay |
      | 10000                   | single           | 1                    | 1423                 | 1           |
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 50000     | 5350      | 7012     |
      | debtId | 50000     | 5350      | 7013     |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns a matching single payment instalment plan
#    Then ifs service returns single payment frequency instalment calculation plan