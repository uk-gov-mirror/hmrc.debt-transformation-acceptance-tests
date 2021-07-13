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

Feature: Payment plan calculation duration for 1 debt 1 duty based on instalment amount and frequency

  @plan
  Scenario: Payment plan calculation instalment - no initial payment

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | outstandingInterest |
      | debtId | 100000     | 10000            | monthly          | 2021-06-01     | 1525      | 1000     | 1423                |
    When the payment plan detail is sent to the ifs service
    Then ifs returns payment frequency summary
      | totalDebtAmount | totalPlanInt | interestAccrued |
      | 102617          | 1194         | 1423            |
    Then ifs service return the following payment plan calculation instalment
      | serialNo | paymentDueDate | numberOfDays | amountDue | uniqueDebtId | balance | interestDue | totalPaidAmount | intRate |
      | 1        | 2021-06-01     | 30           | 10000     | debtId       | 100000  | 213         | 10000           | 2.6     |
      | 2        | 2021-07-01     | 31           | 10000     | debtId       | 90000   | 198         | 20000           | 2.6     |
      | 3        | 2021-08-01     | 31           | 10000     | debtId       | 80000   | 176         | 30000           | 2.6     |
      | 4        | 2021-09-01     | 30           | 10000     | debtId       | 70000   | 149         | 40000           | 2.6     |
      | 5        | 2021-10-01     | 31           | 10000     | debtId       | 60000   | 132         | 50000           | 2.6     |
      | 6        | 2021-11-01     | 30           | 10000     | debtId       | 50000   | 106         | 60000           | 2.6     |
      | 7        | 2021-12-01     | 31           | 10000     | debtId       | 40000   | 88         | 70000           | 2.6     |
      | 8        | 2022-01-01     | 31           | 10000     | debtId       | 30000   | 66          | 80000           | 2.6     |
      | 9        | 2022-02-01     | 28           | 10000     | debtId       | 20000   | 39          | 90000           | 2.6     |
      | 10       | 2022-03-01     | 31           | 10000     | debtId       | 10000   | 22          | 100000          | 2.6     |
      | 11       | 2022-04-01     | 30           | 2617      | debtId       | 0       | 0           | 102617          | 2.6     |



#  @plan
  Scenario: Payment plan calculation instalment - initial payment

    Given debt payment plan details
      | debtId | debtAmount | instalmentAmount | paymentFrequency | instalmentDate | mainTrans | subTrans | outstandingInterest |
      | debtId | 100000     | 10000            | monthly          | 2021-06-01     | 1525      | 1000     | 1423                |
    When the payment plan detail is sent to the ifs service

    Then ifs returns payment frequency summary
      | totalDebtAmount | totalPlanInt | interestAccrued |
      | 102617          | 1194         | 1423            |

    Then ifs service return the following payment plan calculation instalment
      | serialNo | paymentDueDate | numberOfDays | amountDue | uniqueDebtId | balance | interestDue | totalPaidAmount | intRate |
      | 1        | 2021-07-07     | 2            | 3         | 4            | 5       | 6           | 7               | 8       |
