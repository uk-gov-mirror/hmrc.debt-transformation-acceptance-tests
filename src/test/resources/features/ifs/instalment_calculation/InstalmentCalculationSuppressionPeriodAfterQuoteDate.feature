@instalmentsWithSuppression
Feature: Suppression Period ends after quote date

  Scenario: Instalment calculation has been requested where a postcode suppression period ends after the quote date
    Given suppression data has been created
      | suppressionId | code | reason      | description | enabled | fromDate  | toDate            |
      | 9             | 9    | LEGISLATIVE | COVID       | true    | yesterday | 2 months from now |
    And suppression rules have been created
      | ruleId | postCode | suppressionIds |
      | 1      | BS39 5DP | 9              |
    And debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal |
      | 10000                   | monthly          | 1                    | 1423                 |
    And the instalment calculation has postcode BS39 5DP with postcode date a year in the past
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then the IFS request should return status 200
    And the 1st instalment should have an interest accrued of 0
    And the 2nd instalment should have an interest accrued of 0

  Scenario: Instalment calculation has been requested where a period end suppression period ends after the quote date
    Given suppression data has been created
      | suppressionId | code | reason      | description | enabled | fromDate  | toDate            |
      | 10            | 10   | LEGISLATIVE | COVID       | true    | yesterday | 2 months from now |
    And suppression rules have been created
      | ruleId | mainTrans | suppressionIds |
      | 2      | 1525      | 10             |
    And debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal |
      | 10000                   | monthly          | 1                    | 1423                 |
    And the instalment calculation has postcode TW3 with postcode date a year in the past
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then the IFS request should return status 200
    And the 1st instalment should have an interest accrued of 0
    And the 2nd instalment should have an interest accrued of 0

  Scenario: Instalment calculation has been requested where a main trans suppression period ends after the quote date
    Given suppression data has been created
      | suppressionId | code | reason      | description | enabled | fromDate  | toDate            |
      | 11            | 11   | LEGISLATIVE | COVID       | true    | yesterday | 2 months from now |
    And suppression rules have been created
      | ruleId | periodEnd  | suppressionIds |
      | 1      | 2021-08-16 | 11             |
    And debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDay | interestCallDueTotal |
      | 10000                   | monthly          | 1                    | 1423                 |
    And the instalment calculation has postcode TW3 with postcode date a year in the past
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans | periodEnd  |
      | debtId | 100000     | 1525      | 1000     | 2021-08-16 |
    When the instalment calculation detail is sent to the ifs service
    Then the IFS request should return status 200
    And the 1st instalment should have an interest accrued of 0
    And the 2nd instalment should have an interest accrued of 0
