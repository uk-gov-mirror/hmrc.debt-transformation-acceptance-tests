Feature: Payment plan frequency calculation for 1 debt 1 duty with initial payment

  @thads
  Scenario: Payment plan calculation instalment - Single payment frequency
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal | numberOfDay |
      | 10000                   | single           | 2022-12-01            | 1423                 |     1       |
    And no initial payment for the debtItem
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1530      | 1000     |
    And no initial payment for the debtItem
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns single payment frequency instalment calculation plan

  Scenario: Payment plan calculation instalment - weekly payment frequency
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal |
      | 10000                   | weekly           | 2021-12-01            | 1423                 |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns weekly payment frequency instalment calculation plan

  Scenario: Payment plan calculation instalment - 2Weekly payment frequency
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal |
      | 10000                   | 2Weekly          | 2021-12-01            | 1423                 |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1530      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    And ifs service returns 2-Weekly frequency instalment calculation plan

  Scenario: Payment plan calculation instalment - 4Weekly payment frequency with end of month instalment start Date
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal |
      | 10000                   | 4Weekly          | 2021-12-01            | 1423                 |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1530      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns 4-Weekly frequency instalment calculation plan

  Scenario: Payment plan calculation instalment - Monthly payment frequency type
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal |
      | 10000                   | monthly          | 2021-12-01            | 9542                 |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns monthly payment frequency instalment calculation plan

  Scenario: Payment plan calculation instalment - Quarterly payment frequency with end of Leap year instalment Date
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal |
      | 10000                   | quarterly        | 2021-12-01            | 1423                 |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    And ifs service returns Quarterly payment frequency instalment calculation plan

  Scenario: Payment plan calculation instalment - 6Monthly payment frequency instalment Date starts in non leap year to Leap year

    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal |
      | 10000                   | 6Monthly         | 2021-12-01            | 3538                 |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    And ifs service returns 6Monthly payment frequency instalment calculation plan

  Scenario: Payment plan calculation instalment - Annually payment frequency
    Given debt instalment calculation with details
      | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | interestCallDueTotal |
      | 10000                   | annually         | 2021-12-01            | 1423                 |
    And the instalment calculation has debt item charges
      | debtId | debtAmount | mainTrans | subTrans |
      | debtId | 100000     | 1525      | 1000     |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns Annually payment frequency instalment calculation plan

  Scenario: Single debt payment instalment calculation plan - Monthly payments with initial payment
    Given debt instalment instalment calculation request details
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | mainTrans | subTrans | interestCallDueTotal | initialPaymentAmount |
      | debtId | 100000     | 10000                   | monthly          | 1525      | 1000     | 1423                 | 100                  |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns monthly instalment calculation plan with initial payment

  Scenario: Single debt payment instalment calculation plan - Weekly payments with initial payment 129
    Given debt plan details with initial payment
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | mainTrans | subTrans | interestCallDueTotal | initialPaymentAmount |
      | debtId | 100000     | 5000                    | weekly           | 1525      | 1000     | 2051                 | 5000                 |
    And add initial payment for the debtItem
      | initialPaymentAmount | initialPaymentDays |
      | 5000                 | 129                |
    When the instalment calculation detail is sent to the ifs service
    Then ifs service returns weekly frequency instalment calculation plan with initial payment
    
#   need to fix step def and request to add capability for multiple debt item charges. See todo's
  @wip
  Scenario: Payment plan calculation request -initialPaymentAmount missing
    Given plan details with no initial payment amount
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | quoteDate  | mainTrans | subTrans | interestCallDueTotal |
      | debtId | 100000     | 10000                   | single           | 2024-07-01            | 2021-07-01 | 1530      | 1000     | 1423                 |
    When the instalment calculation detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message {"statusCode":400,"reason":"Invalid JSON error from IFS","message":"Both Initial Payment Date and Initial Payment Amount should be given"}
    
#   need to fix step def and request to add capability for multiple debt item charges. See todo's
  @wip
  Scenario: Payment plan calculation request -initialPaymentDate missing
    Given plan details with no initial payment date
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | quoteDate  | mainTrans | subTrans | interestCallDueTotal | initialPaymentAmount |
      | debtId | 100000     | 10000                   | single           | 2024-07-01            | 2021-07-01 | 1530      | 1000     | 1423                 | 1000                 |
    When the instalment calculation detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message {"statusCode":400,"reason":"Invalid JSON error from IFS","message":"Both Initial Payment Date and Initial Payment Amount should be given"}
    
#   need to fix step def and request to add capability for multiple debt item charges. See todo's
  @wip
  Scenario: Payment plan calculation request -initialPaymentDate is after instalmentPaymentDate
    Given plan details with initialPaymentDate is after instalmentPaymentDate
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | mainTrans | subTrans | interestCallDueTotal | initialPaymentAmount |
      | debtId | 100000     | 10000                   | single           | 1530      | 1000     | 1423                 | 1000                 |
    When the instalment calculation detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message {"statusCode":400,"reason":"Invalid JSON error from IFS","message":"The Initial Payment Date should be on or before Instalment Payment Date"}

        
#   need to fix step def and request to add capability for multiple debt item charges. See todo's
  @wip
  Scenario: Payment plan calculation request error  - instalmentPaymentDate missing
    Given plan details with no instalment date
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | mainTrans | subTrans | interestCallDueTotal |
      | debtId | 100000     | 10000                   | monthly          | 1530      | 1000     | 1423                 |
    When the instalment calculation detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message {"statusCode":400,"reason":"Invalid JSON error from IFS","message":"Field at path '/instalmentPaymentDate' missing or invalid"}
    
#   need to fix step def and request to add capability for multiple debt item charges. See todo's
  @wip
  Scenario: Payment plan calculation request error  - quote date in past
    Given plan details with quote date in past
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | mainTrans | subTrans | interestCallDueTotal |
      | debtId | 100000     | 10000                   | monthly          | 1530      | 1000     | 1423                 |
    When the instalment calculation detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message {"statusCode":400,"reason":"Invalid JSON error from IFS","message":"Could not parse body due to requirement failed: Quote Date must be today's Date."}
    
#   need to fix step def and request to add capability for multiple debt item charges. See todo's
  @wip
  Scenario: Payment plan calculation request error  -quoteDate missing
    Given plan details with no quote date
      | debtId | debtAmount | instalmentPaymentAmount | paymentFrequency | instalmentPaymentDate | quoteDate | mainTrans | subTrans | interestCallDueTotal |
      | debtId | 100000     | 10000                   | monthly          | 2021-07-01            |           | 1530      | 1000     | 1423                 |
    When the instalment calculation detail is sent to the ifs service
    Then Ifs service returns response code 400
    And Ifs service returns error message {"statusCode":400,"reason":"Invalid JSON error from IFS","message":"Field at path '/quoteDate' missing or invalid"}
