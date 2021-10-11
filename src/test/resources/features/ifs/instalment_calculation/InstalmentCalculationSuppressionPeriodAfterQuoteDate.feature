@instalmentsWithSuppression
Feature: Suppression Period ends after quote date

  Scenario: Instalment calculation has been requested where a postcode suppression period ends after the quote date
    Given a suppression with ID 9, code COVID, reason Covid relief and description No interest accrued due to covid has been applied from yesterday for 2 months
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | TW3      | 9              |
    And debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal |
      | 10000                   | monthly          | 1                    | 1423                 |
    And the instalment calculation has postcode TW3 with postcode date a year in the future
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then the IFS request should return status 200
    And the instalment at index 0 should have an interest accrued of 0
    And the instalment at index 1 should have an interest accrued of 0

  Scenario: Instalment calculation has been requested where a period end suppression period ends after the quote date
    Given a suppression with ID 10, code COVID, reason Covid relief and description No interest accrued due to covid has been applied from yesterday for 2 months
    And suppression rules have been created
      | ruleId | mainTrans | suppressionIds |
      | 2      | 1525      | 10             |
    And debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal |
      | 10000                   | monthly          | 1                    | 1423                 |
    And the instalment calculation has postcode TW3 with postcode date a year in the future
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then the IFS request should return status 200
    And the instalment at index 0 should have an interest accrued of 0
    And the instalment at index 1 should have an interest accrued of 0

  Scenario: Instalment calculation has been requested where a main trans suppression period ends after the quote date
    Given a suppression with ID 11, code COVID, reason Covid relief and description No interest accrued due to covid has been applied from yesterday for 2 months
    And suppression rules have been created
      | ruleId | periodEnd  | suppressionIds |
      | 1      | 2021-08-16 | 11             |
    And debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal |
      | 10000                   | monthly          | 1                    | 1423                 |
    And the instalment calculation has postcode TW3 with postcode date a year in the future
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans | periodEnd  |
      | debtId | 100000     | 1525      | 1000     | 2021-08-16 |
    When the instalment calculation detail is sent to the ifs service
    Then the IFS request should return status 200
    And the instalment at index 0 should have an interest accrued of 0
    And the instalment at index 1 should have an interest accrued of 0
