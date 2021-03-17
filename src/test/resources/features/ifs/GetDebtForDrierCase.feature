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

  Scenario: Non Interest Bearing DRIER debt (MVP)
    Given a debt item
      | amount | dateAmount  | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | today - 100 | today + 20        | drier  | DRIER-NI   | false           |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 0.0     | 5000             | 5000                    | 0                    |

  Scenario: DRIER debt Zero Amount Edge Case
    Given a debt item
      | amount | dateAmount  | dateCalculationTo | regime | chargeType | interestBearing |
      | 0      | today - 100 | today + 20        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1.0     | 0                | 0                       | 120                  |

  Scenario: DRIER debt Date Amount is Today (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | today      | today + 20        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 2.73          | 1.0     | 5000             | 5002.73                 | 20                   |

  Scenario: DRIER debt Date Calculation To is Today (Edge Case)
    Given a debt item
      | amount | dateAmount  | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | today - 100 | today             | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0.1369        | 13.69         | 1.0     | 5000             | 5013.69                 | 100                  |

  Scenario: DRIER debt Date Amount is Today + 1 day (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | today + 1  | today + 20        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with error message "date amount cannot be in future????"

  Scenario: DRIER debt DateCalculationTo is Today - 1 day (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | today      | today -1          | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with error message "date calculation to cannot be in the past???"

  Scenario: DRIER debt Amount is zero (Edge Case)
    Given a debt item
      | amount | dateAmount  | dateCalculationTo | regime | chargeType | interestBearing |
      | 0      | today - 100 | today             | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with tbc
      | dailyInterest | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays |
      | 0             | 0             | 1.0     | 0                | 0                       | 100                  |

  Scenario: DRIER debt Date Amount is negative (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | -1     | today      | today + 20        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with error message "Amount cannot be negative???" tbc

  Scenario: DRIER debt Amount non integer (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | a      | today      | today + 20        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with error message "Amount must be an number" tbc

  Scenario: DRIER debt Date Amount non date (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | blah       | today + 20        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with error message "Date amount must be a date" tbc

  Scenario: DRIER debt Date Calculation To non date (Edge Case)
    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 5000   | blah       | 31/02/2050        | drier  | DRIER-HiPG | true            |
    When the debt item is sent to the ifs service
    Then the ifs service will respond with error message "Date Calculation To must be a valid date" tbc







