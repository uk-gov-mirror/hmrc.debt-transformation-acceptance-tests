#Assumptions
#
#Customer reference = see format from ARC
#Debt amount = 1,200
#Debt ID = see format from ARC
#Duty ID = see format from ARC
#Main Trans = 1545 (interest bearing)
#Sub Trans = 1000
#Original debt amount = 1,200
#Payment amount = 200
#Payment date = 25/08/2020
#Interest start date = 05/04/2020
#Quote type = Duration
#Instalment date = 01/06/2021
#Instalment amount = 100
#Frequency = monthly
#Duration = Not known as IFS will calculate
#No initial payment
#No suppressions
#No BS
#Type of payment plan = Time to pay - not relevant for IFS to do calculation


Feature: Payment plan frequency calculation for 1 debt 1 duty with no initial payment

  Scenario: Payment plan calculation instalment - Single payment frequency

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | Single           | 2021-12-01     | 1530      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    Then ifs service returns single payment freqeuncy instalment calculation plan
  @wip24
  Scenario: Payment plan calculation instalment - weekly payment frequency

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | Weekly           | 2021-06-01     | 1525      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    Then ifs service returns weekly payment freqeuncy instalment calculation plan


  Scenario: Payment plan calculation instalment - 2-Weekly payment frequency
    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | 2-Weekly         | 2021-06-01     | 1530      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    And ifs service returns 2-Weekly freqeuncy instalment calculation plan

  Scenario: Payment plan calculation instalment - 4-Weekly payment frequency with end of month instalment start Date

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | 4-Weekly         | 2021-06-01    | 1530      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    Then ifs service returns 4-Weekly freqeuncy instalment calculation plan

  Scenario: Payment plan calculation instalment - Monthly payment frequency type

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | Monthly          | 1525      | 1000     | 9542            |
    When the payment plan detail is sent to the ifs service
    Then ifs service returns monthly payment freqeuncy instalment calculation plan


  Scenario: Payment plan calculation instalment - Quarterly payment frequency with end of Leap year instalment Date

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | Quarterly        | 2020-01-15     | 1525      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    And ifs service returns Quarterly payment freqeuncy instalment calculation plan

  Scenario: Payment plan calculation instalment - HalfYearly payment frequency instalment Date starts in non leap year to Leap year

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | HalfYearly       | 2019-12-31     | 1525      | 1000     | 3538            |
    When the payment plan detail is sent to the ifs service
    And ifs service returns HalfYearly payment freqeuncy instalment calculation plan

  Scenario: Payment plan calculation instalment - Annually payment frequency
    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | Annually         | 1525      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    Then ifs service returns Annually payment freqeuncy instalment calculation plan

  Scenario: Payment plan calculation request -quoteDate
    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | Single           | 2021-12-01     | 1530      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message{"statusCode": 400,"reason": "Invalid Json","message": "Field at path '/quoteDate' missing or invalid"}

  Scenario: Payment plan calculation request error  -instalmentDate same as quoteDate date or missing
    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | interestAccrued |
      | debtId | 100000     | 10000            | Single           | 2021-12-01     | 1530      | 1000     | 1423            |
    When the payment plan detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message {"statusCode": 400,"reason": "Invalid Json","message": "Field at path '/instalmentDate' missing or invalid\nField at path '/quoteDate' missing or invalid"}
