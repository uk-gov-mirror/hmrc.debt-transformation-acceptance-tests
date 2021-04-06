#  Assumptions
#  Initial amount and date
#  REGIME == DRIERd
#  NO suppression period
#  NO breathing space
#  Date Amount  == Interest start date


#Multiple Debt Items
#1 payment of 1 debt no interest
#1 payment of 1 debt with interest
#2 payments of 1 debt with interest
#2 debts, 1 debt with a payment, the second debt with no payment

Feature: Get Debt For DRIER case (mvp)
  @wip
  Scenario: for testing 198. Interest Bearing. 0 Payments, 1 debt.

    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2021-03-01 | 2021-03-08        | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service wilL return a debt summary of
      | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays | dailyInterest |
      | 109           | 1       | 500000           | 500109                  | 8                    | 13            |
    And the debt summary will have calculation windows
      | dateFrom   | dateTo     | numberDays | intRate | dailyInterest | totalInterest |
      | 2020-03-01 | 2021-03-08 | 8          | 1       | 13            | 109           |
