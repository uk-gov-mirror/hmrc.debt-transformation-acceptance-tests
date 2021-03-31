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
@wip
Feature: Get Debt For DRIER case (mvp)

  Scenario: 1. Non Interest Bearing. 1 Payment of 1 debt.

    Given a debt item
      | amount | dateAmount | dateCalculationTo | regime | chargeType | interestBearing |
      | 500000 | 2020-12-16 | 2021-04-14        | DRIER  | NI         | true            |
    When the debt item is sent to the ifs service
    Then the ifs response code should be 200
    Then the ifs service wilL return a debt summary of
      | totalInterest | intRate | totalAmountToPay | totalAmountWithInterest | numberChargeableDays | dailyInterest |
      | 1643          | 1       | 500000           | 501643                  | 120                  | 13            |