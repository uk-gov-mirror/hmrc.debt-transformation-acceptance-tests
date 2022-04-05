Feature: Instalment calculation for multiple debts - Input 1 & 2
  #  Input 1
  Scenario: Should calculate quote for multiple debts with interest bearing & non-interest bearing debts combined
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal | numberOfDay | quoteType | quoteDate  |
      | 10000                   | monthly          | 2022-03-14            | 5900                 | 1           | duration  | 2022-03-13 |
    And the instalment calculation has no postcodes
    And debt plan details with initial payment
      | initialPaymentAmount | initialPaymentDate |
      | 100                  | 2022-03-14         |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | 1234   | 80000      | 1525      | 1000     |
      # interest bearing debt
      | 12345  | 70000      | 1541      | 2000     |
      # non-interest bearing debt
    When the instalment calculation detail is sent to the ifs service
    Then IFS response contains expected values
      | instalmentNumber | dueDate    | paymentFrequency | frequencyPassed | amountDue | instalmentBalance | interestRate | expectedNumberOfInstalments |
      | 9                | 2022-10-14 | monthly          | 7               | 100       | 70000             | 0            | 17                          |

  Scenario: Should calculate quote for multiple debts both with interest bearing & 1 initial payment history
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal | numberOfDay | quoteType | quoteDate  |
      | 10000                   | monthly          | 2022-03-14            | 5900                 | 1           | duration  | 2022-03-13 |
    And the instalment calculation has no postcodes
    And debt plan details with initial payment
      | initialPaymentAmount | initialPaymentDate |
      | 100                  | 2022-03-14         |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | 1234   | 80000      | 1525      | 1000     |
      # interest bearing debt
      | 12345  | 70000      | 1530      | 1000     |
      # interest bearing debt
    When the instalment calculation detail is sent to the ifs service
    Then IFS response contains expected values
      | instalmentNumber | dueDate    | paymentFrequency | frequencyPassed | amountDue | instalmentBalance | interestRate | expectedNumberOfInstalments |
      | 1                | 2022-03-14 | monthly          | 0               | 10100     | 80000             | 3.0          | 17                          |

    #  Input 2

  Scenario: Should calculate debts amount for 1 debt 1 duty with initial payment (input 2)
    Given debt instalment calculation with details
      | duration | paymentFrequency | instalmentPaymentDate | interestCallDueTotal | numberOfDay | quoteType        | quoteDate  |
      | 24       | monthly          | 2022-03-14            | 0                    | 1           | instalmentAmount | 2022-03-13 |
    And the instalment calculation has no postcodes
    And debt plan details with initial payment
      | initialPaymentAmount | initialPaymentDate |
      | 100                  | 2022-03-14         |
    And the instalment calculation has debt item charges
      | debtId     | debtAmount | mainTrans | subTrans |
      | TPSSDebt1  | 100000     | 1525      | 1000     |
      | DRIERDebt1 | 100000     | 1085      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then IFS response contains expected values
      | instalmentNumber | dueDate    | paymentFrequency | frequencyPassed | amountDue | instalmentBalance | interestRate | expectedNumberOfInstalments |
      | 1                | 2022-03-14 | monthly          | 0               | 8491      | 100000            | 3.0          | 25                          |