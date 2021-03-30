#  Assumptions
#  Initial amount and date
#  REGIME == DRIERd
#  NO suppression period
#  NO breathing space
#  Date Amount  == Interest start date


Multiple Debt Items
#1 payment of 1 debt no interest
#1 payment of 1 debt with interest
#2 payments of 1 debt with interest
#2 debts, 1 debt with a payment, the second debt with no payment
@wip
Feature: Get Debt For DRIER case (mvp)

  Scenario: 1. Non Interest Bearing. 1 Payment of 1 debt.

    Given a debt item
      | amount | interestStartDate | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has payments
      | payment | paymentDate |
      | 100000  | 2021-02-03  |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with a debt summary of
      | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0       | 400000           | 400000                  | 0                    |
    And the debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest |
      | 2020-12-16 | 2021-02-03 | 50         | 0       | 0             | 0             |
      | 2021-02-04 | 2021-04-14 | 70         | 0       | 0             | 0             |

  Scenario: 2. Interest Bearing. 1 Payment of 1 debt.

    Given a debt item
      | amount | interestStartDate | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has payments
      | payment | paymentDate |
      | 100000  | 2021-02-03  |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with a debt summary of
      | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays | dailyInterest |
      | 1451          | 0       | 400000           | 401451                  | 120                  | 10            |
    And the debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest |
      | 2020-12-16 | 2021-02-03 | 50         | 1       | 13            | 684           |
      | 2021-02-04 | 2021-04-14 | 70         | 1       | 10            | 767           |

  Scenario: 3. Interest Bearing. 2 Payments of 1 debt.
    Given a debt item
      | amount | interestStartDate | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has payments
      | payment | paymentDate |
      | 100000  | 2021-02-23  |
      | 100000  | 2021-03-05  |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with a debt summary of
      | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays | dailyInterest |
      | 1395          | 1       | 300000           | 301395                  | 120                  | 8             |
    And the debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest |
      | 2020-12-16 | 2021-02-23 | 70         | 1       | 13            | 958           |
      | 2021-02-24 | 2021-03-05 | 10         | 1       | 10            | 109           |
      | 2021-03-06 | 2021-04-14 | 40         | 1       | 8             | 328           |


  Scenario: 4. Interest Bearing. 2 debts. 1 debt with payment the second debt with no payment.
    Given a debt item
      | amount | interestStartDate | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    And the debt item has payments
      | payment | paymentDate |
      | 100000  | 2021-02-23  |
    And a debt item
      | amount | interestStartDate | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with a debt summary of
      | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | dailyInterest |
      | 2094          | 1       | 900000           | 902094                  | 23            |
    And the debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest |
      | 2020-12-16 | 2021-02-03 | 50         | 1       | 13            | 684           |
      | 2021-02-04 | 2021-04-14 | 70         | 1       | 10            | 767           |
      | 2021-12-16 | 2021-04-14 | 120        | 1       | 13            | 1643          |

    And each debt will have a summary section
      | totalInterest | interestRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays | interestsDueAmount? | dailyInterest |
      | 1451          | 1            | 400000           | 401451                  | 120                  | 400000              | 10            |
      | 1643          | 1            | 500000           | 501643                  | 120                  | 500000              | 13            |
#    Given a rule
#      | regime | chargeType | intRate | otherwise |
#      | DRIER  | NI         | 1       | 0         |


