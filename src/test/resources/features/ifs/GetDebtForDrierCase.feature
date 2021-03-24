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
      | 500000 | -100       | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 16.42         | 1       | 5000             | 5016.42                 | 120                  |

  Scenario: Non Interest Bearing DRIER debt (MVP)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | -100       | 20                | DRIER  | HIPG       | false           |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 0       | 5000             | 5000                    | 120                  |
#
  Scenario: DRIER debt Zero Amount Edge Case
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 0      | -100       | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1       | 0                | 0                       | 120                  |

  Scenario: DRIER debt Date Amount is Today (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 0          | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 2.73          | 1       | 5000             | 5002.73                 | 20                   |
#
  Scenario: DRIER debt Date Calculation To is Today (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | -100       | 0                 | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 13.69         | 1       | 5000             | 5013.69                 | 100                  |
#
  Scenario: DRIER debt Date Amount is Today + 1 day (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 1          | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 2.6           | 1       | 5000             | 5002.6                  | 19                   |
#
  Scenario: DRIER debt DateCalculationTo is Today - 1 day (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 1          | -1                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 0             | 1       | 5000             | 5000                    | 0                    |
#
  Scenario: DRIER debt Amount is zero (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 0      | -100       | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1       | 0                | 0                       | 120                  |

#Below scenario currently fails as api returns daily interest of -0.0001. Should negative amounts be possible?
  Scenario: DRIER debt Amount is negative (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | -1     | -100       | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1       | 0                | 0                       | 120                  |

  Scenario: DRIER debt Amount non integer (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | n      | -100       | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with '/amount' missing or invalid

#    Below scenario currently fails. api should not accept decimal places. DTD-191 to fix this
  Scenario: DRIER debt Amount non integer (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 1.0    | -100       | 20                | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with '/amount' missing or invalid
