#  Assumptions
#  Initial amount and date
#  REGIME == DRIERd
#  NO suppression period
#  NO breathing space
#  Date Amount  == Interest start date

#Single debt to verify test can parse Calculation Window object.
#Currently fails (6/4) as dailyInterest and totalInterest are returning zero


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
      | 2021-03-01 | 2021-03-08 | 8          | 1       | 13            | 109           |
