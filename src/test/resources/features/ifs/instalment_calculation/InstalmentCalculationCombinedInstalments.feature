Feature: Instalment calculation with combined instalments

  Scenario: Final two instalments are merged when requested
    Given debt instalment calculation with details
      | instalmentPaymentAmount | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType | quoteDate  |
      | 1000                    | 2021-08-01            | monthly          | 300                  | duration  | 2021-06-10 |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 4000       | 1525      | 1000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | true                   |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 4                   | 4        | 300             | 27           | 327           |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue |
      | 1                | 2021-08-01 | 1000      |
      | 4                | 2021-11-01 | 1327      |

  Scenario: Final two instalments are not merged when when request to merge is false
    Given debt instalment calculation with details
      | instalmentPaymentAmount | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType | quoteDate  |
      | 1000                    | 2021-08-01            | monthly          | 300                  | duration  | 2021-06-10 |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 4000       | 1525      | 1000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | false                  |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 5                   | 5        | 300             | 27           | 327           |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue |
      | 1                | 2021-08-01 | 1000      |
      | 5                | 2021-12-01 | 327       |

  Scenario:  Plan with isQuoteDateNonInclusive flag should not include quote date in interest accrued
    Given debt instalment calculation with details
      | duration | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType        | quoteDate  | isQuoteDateNonInclusive |
      | 6        | 2023-04-20            | monthly          | 178                  | instalmentAmount | 2023-03-17 | true                    |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 100000     | 1525      | 1000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | false                  |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 6                   | 6        | 178             | 1961         | 2139          |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue | instalmentInterestAccrued |
      | 1                | 2023-04-20 | 17022     | 605                       |
      | 6                | 2023-09-20 | 17029     | 92                        |

  Scenario: Plans with initial payment and isQuoteDateNonInclusive flag should not include quote date
    Given debt instalment calculation with details
      | duration | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType        | quoteDate  | isQuoteDateNonInclusive |
      | 4        | 2023-05-20            | monthly          | 0                    | instalmentAmount | 2023-03-23 | true                    |
    And the instalment calculation has no postcodes
    And debt plan details with initial payment
      | initialPaymentAmount | initialPaymentDate |
      | 100000               | 2023-04-02         |
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 1425623    | 1525      | 1000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | false                  |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 5                   | 4        | 0               | 24727        | 24727         |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue | instalmentInterestAccrued |
      | 1                | 2023-04-02 | 100000    | 2538                      |
      | 5                | 2023-08-20 | 337592    | 1829                      |

  Scenario: Final two instalments of non interest bearing debts are not merged when when request to merge is false
    Given debt instalment calculation with details
      | instalmentPaymentAmount | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType | quoteDate  |
      | 999                     | 2021-08-01            | monthly          | 0                    | duration  | 2021-06-10 |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 4000       | 1541      | 2000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | false                  |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 5                   | 5        | 0               | 0            | 0             |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue |
      | 1                | 2021-08-01 | 999       |
      | 5                | 2021-12-01 | 4         |

  Scenario: Final two instalments of non interest bearing debts are merged when when requested
    Given debt instalment calculation with details
      | instalmentPaymentAmount | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType | quoteDate  |
      | 999                     | 2021-08-01            | monthly          | 0                    | duration  | 2021-06-10 |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 4000       | 1541      | 2000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | true                   |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 4                   | 4        | 0               | 0            | 0             |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue |
      | 1                | 2021-08-01 | 999       |
      | 4                | 2021-11-01 | 1003      |

  Scenario: Final two instalments are merged when requested with initial payment
    Given debt instalment calculation with details
      | instalmentPaymentAmount | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType | quoteDate  |
      | 999                     | 2021-08-01            | monthly          | 300                  | duration  | 2021-06-10 |
    And the instalment calculation has no postcodes
    And debt plan details with initial payment
      | initialPaymentAmount | initialPaymentDate |
      | 1000                 | 2021-07-01         |
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 4000       | 1525      | 1000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | true                   |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 4                   | 3        | 300             | 18           | 318           |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue |
      | 1                | 2021-07-01 | 1000      |
      | 2                | 2021-08-01 | 999       |
      | 4                | 2021-10-01 | 1320      |

  Scenario: Multiple debt item charges final two instalments are merged when requested
    Given debt instalment calculation with details
      | instalmentPaymentAmount | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType | quoteDate  |
      | 6000                    | 2021-08-01            | monthly          | 1000                 | duration  | 2021-06-10 |
    And the instalment calculation has no postcodes
    And debt plan details with initial payment
      | initialPaymentAmount | initialPaymentDate |
      | 5000                 | 2021-07-01         |
    And the instalment calculation has debt item charges
      | debtId     | debtAmount | mainTrans | subTrans |
      | TPSSDebt1  | 16000      | 1525      | 1000     |
      | DRIERDebt1 | 14000      | 1525      | 1000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | true                   |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 6                   | 4        | 1000            | 185          | 1185          |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue |
      | 1                | 2021-07-01 | 5000      |
      | 2                | 2021-08-01 | 6000      |
      | 6                | 2021-11-01 | 8185      |

  Scenario: Last 2 instalments are only combined where final instalment amount is lower than previous
    Given debt instalment calculation with details
      | instalmentPaymentAmount | instalmentPaymentDate | paymentFrequency | interestCallDueTotal | quoteType | quoteDate  |
      | 1006                    | 2021-08-01            | monthly          | 1003                 | duration  | 2021-06-10 |
    And the instalment calculation has no postcodes
    And no initial payment for the debt item charge
    And the instalment calculation has debt item charges
      | debtId    | debtAmount | mainTrans | subTrans |
      | TPSSDebt1 | 4000       | 1525      | 1000     |
    When the instalment calculation is sent to the ifs service with query parameters
      | combineLastInstalments |
      | true                   |
    Then the instalment calculation summary contains values
      | numberOfInstalments | duration | interestAccrued | planInterest | totalInterest |
      | 5                   | 5        | 1003            | 27           | 1030          |
    And IFS response contains expected values
      | instalmentNumber | dueDate    | amountDue |
      | 1                | 2021-08-01 | 1006      |
      | 5                | 2021-12-01 | 1006      |



