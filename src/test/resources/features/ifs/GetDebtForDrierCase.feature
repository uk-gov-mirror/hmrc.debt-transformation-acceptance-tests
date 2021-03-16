#  Assumptions
#  1 Debt item
#  Initial amount and date
#  REGIME == DRIERd
#  Where charge type is DRIER NI, then interest bearing is assumed to be false
#  Where charge type is DRIER HiPG, then interest bearing is assumed to be true
#  NO repayments
#  NO suppression period
#  NO breathing space
#  Date Amount  == Interest start date
#  No outstanding interests to pay
#  When bearing the interest rate is 1%

@ignore @wip
Feature: Get Debt For DRIER case (mvp)
  Scenario: Interest Bearing DRIER debt (MVP)
    Given a debt item
      | amount | dateAmount  | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | today - 100 | today + 20        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 16.43         | 1.0     | 5000             | 5016.43                 | 120                  |

  Scenario: Non bearing interest DRIER debt (MVP)
    Given a debt item
      | amount | dateAmount  | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | today - 100 | today + 20        | drier  | DRIER-NI   | false           |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 0.0     | 5000             | 5000                    | 120                  |


