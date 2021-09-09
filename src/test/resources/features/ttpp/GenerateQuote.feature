Feature: Retrieve generate quote response from Time to Pay Proxy

  Scenario: Single instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | single    | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  Scenario: Weekly instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | weekly    | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  Scenario:  2Weekly instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | 2Weekly   | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  Scenario:  4Weekly instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | 4Weekly   | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  Scenario:  Monthly instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | monthly   | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  Scenario:  quarterly instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | quarterly | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  Scenario:  6Monthly instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | 6Monthly  | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  Scenario:  Annually instalment payment frequency with for 1 debt -No initial payment
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | annually  | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service is going to return a generate quote response with
      | quoteReference | customerReference | quoteType        | quoteDate  | numberOfInstalments | totalDebtincInt | interestAccrued | planInterest |
      | quoteRef1234   | custRef1234       | instalmentAmount | 2021-05-13 | 1                   | 10              | 10              | 0.25         |
    And the 2nd instalment will contain
      | debtItemChargeId  | debtItemId  | dueDate    | amountDue | expectedPayment | interestRate | instalmentNumber | instalmentInterestAccrued | instalmentBalance |
      | debtItemChargeId1 | debtItemId1 | 2021-05-13 | 100       | 100             | 0.24         | 1                | 10                        | 10                |

  @ignore
  Scenario: TTP service returns  -Invalid paymentAmount of zero.
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | annually  | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | -100            |
    When the generate quote request is sent to the ttpp service
    Then the ttp service will respond with
      | statusCode | reason                       | message                                                                                                                                                                          |
      | 400        | Invalid GenerateQuoteRequest | Invalid GenerateQuoteRequest payload: List((/debtItems(0)/paymentHistory(0)/paymentAmount,List(JsonValidationError(List(error.expected.numberformatexception),WrappedArray())))) |

  @ignore
  Scenario: TTP service returns  -Invalid mainTrans .
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | annually  | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 16        | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service will respond with
      | statusCode | reason                       | message                                                                                                                                             |
      | 400        | Invalid GenerateQuoteRequest | Invalid GenerateQuoteRequest payload: List((/debtItems(0)/mainTrans,List(JsonValidationError(List(error.expected.validenumvalue),WrappedArray())))) |

  @ignore
  Scenario: TTP service returns  -Invalid paymentDate.
    Given a generate quote request
      | customerReference | channelIdentifier |
      | uniqRef1234       | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | annually  | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 13-05-2021  | 100           |
    When the generate quote request is sent to the ttpp service
    Then the ttp service will respond with
      | statusCode | reason                          | message                                                                                                                                                                                                                                                                                            |
      | 400        | Invalid JSON error from TTPStub | Invalid GenerateQuoteRequest payload: List((/debtItems(0)/paymentHistory(0)/paymentDate,List(JsonValidationError(List(error.expected.date.isoformat),WrappedArray(ParseCaseSensitive(false)(Value(Year,4,10,EXCEEDS_PAD)'-'Value(MonthOfYear,2)'-'Value(DayOfMonth,2))[Offset(+HH:MM:ss,'Z')]))))) |

  @ignore
  Scenario: TTP service returns  -Invalid customerReference.
    Given a generate quote request
      | customerReference | channelIdentifier |
      | 100TTP            | selfService       |
    And payment plan details
      | quoteType        | quoteDate  | instalmentStartDate | instalmentAmount | frequency | duration | initialPaymentAmount | initialPaymentDate | paymentPlanType |
      | instalmentAmount | 2021-05-13 | 2021-05-13          | 100              | annually  | 12       | 100                  | 2021-05-13         | timeToPay       |
    And post codes details
      | addressPostcode | postcodeDate |
      | NW9 5XW         | 2021-05-13   |
    And customer debtItem details
      | debtItemId  | debtItemChargeId  | mainTrans | subTrans | originalDebtAmount | interestStartDate |
      | debtItemId1 | debtItemChargeId1 | 1546      | 1090     | 100                | 2021-05-13        |
    And Payments are
      | paymentDate | paymentAmount |
      | 2021-05-13  | 100           |
    When the generate quote request is sent to the ttpp service
    And ttp service returns error message {"status":404,"message":"POST of 'http://localhost:10003/individuals/time-to-pay/quote' returned 404 (Not Found)


