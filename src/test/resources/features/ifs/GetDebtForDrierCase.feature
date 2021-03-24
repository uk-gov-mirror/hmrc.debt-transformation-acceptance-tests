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

#DTD-191: IFS Amounts to be in pennies. Is outstanding

Feature: Get Debt For DRIER case (mvp)

  Scenario: Interest Bearing DRIER debt (MVP)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2021-03-01 | 2021-03-08        | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.13          | 1.09          | 1       | 5000             | 5001.09                 | 8                    |

# Currently fails. Number of chargeable days should be zero
  @ignore
  Scenario: Non Interest Bearing DRIER debt (MVP)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2021-03-01 | 2021-03-08        | DRIER  | HIPG       | false           |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 0       | 5000             | 5000                    | 0          |
#
  Scenario: DRIER debt Zero Amount Edge Case
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 0      | 2021-03-01 | 2021-03-08        | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1       | 0                | 0                       | 8          |

  Scenario: DRIER debt Amount is zero (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 0      | 2021-03-01 | 2021-03-08        | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1       | 0                | 0                       | 8                  |
#Below scenario currently fails as api returns daily interest of -0.0001. Should negative amounts be possible?
  @ignore
  Scenario: DRIER debt Amount is negative (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | -1     | 2021-03-01 | 2021-03-08             | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1       | 0                | 0                       | 8                  |

  Scenario: DRIER debt Amount non integer (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | n      | 2021-03-01 | 2021-03-08               | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with '/amount' missing or invalid

#    Below scenario currently fails. api should not accept decimal places. DTD-191 to fix this
  @ignore
  Scenario: DRIER debt Amount non integer (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 1.0    | 2021-03-01 | 2021-03-08                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with '/amount' missing or invalid
