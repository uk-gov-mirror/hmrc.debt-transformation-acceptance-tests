#!/usr/bin/env bash

# script to poll the GET /requests endpoint in the ET TTP-proxy,
# call the qa ttp endpoint and then return the response back to ET
# If an error is found in any of the requests, processing of the request will end.

#todo Replace below with et-ttp proxy endpoint
ETttpProxyEndpoint="http://localhost:9946/suppressions"

#todo Replace below with qa-ttp proxy endpoint
QAttpProxyEndpoint="http://localhost:9946/suppressions"

ETTokenEndpoint="https://test-api.service.hmrc.gov.uk/oauth/token"
QATokenEndpoint="https://api.qa.tax.service.gov.uk/oauth/token"

# Get token for external test
token_body="client_secret=8ac71009-56c6-4898-b29b-4e5ca95776b8&client_id=zW01C9PlZBhuClygEWTcjTymEibX&grant_type=client_credentials&expires_in=500000 &scope=read:interest-forecasting" # todo replace interest-forecasting with ttp service when deployed
et_token_json=$(curl -s -o token_response.txt -w %{http_code} --request POST --header "content-type: application/x-www-form-urlencoded" --data $token_body $ETTokenEndpoint)
et_token=$(echo $et_token_json | cut -d'"' -f 4)

# Get token for qa
token_body="client_secret=6c2fc716-b9c6-4bb8-a57e-4908d32b9b27&client_id=reRg5ZSks9hGLpzxS5RRnYHjHYtW&grant_type=client_credentials&expires_in=500000 &scope=read:interest-forecasting" # todo replace interest-forecasting with ttp service when deployed
qa_token_json=$(curl -s -o token_response.txt -w %{http_code} --request POST --header "content-type: application/x-www-form-urlencoded" --data $token_body $QATokenEndpoint)
qa_token=$(echo $et_token_json | cut -d'"' -f 4)
echo "*** qa token is $qa_token"

for (( ; ; )); do
  sleep 2
  # Call ET Proxy Endpoint
  echo "********* calling external test ET proxy endpoint ${ETttpProxyEndpoint} to check for requests *********"
  echo "********* et token is $et_token ********"
  et_header_token="'Authorization: bearer $et_token'"
  status_code=$(curl -s -o response.txt -w %{http_code} $ETttpProxyEndpoint --header "$et_header_token")
  echo "*** status code $status_code"

  if [[ "$status_code" -ne 200 ]]; then
    echo "$status_code Error received calling endpoint $ETttpProxyEndpoint Handling error and exiting !!!"
    # todo handle error - by writing a record to db?

    # end processing of request
    continue
  else
    body=$(<response.txt)
    echo " *** Response returned is $body"
    if [[ "$body" != *"customerReference"* ]]; then
      echo "********* no request returned from TTP proxy on ET ********"
      continue
    fi
  # todo uri = get uri from body
  fi

  #make a call to the QA TTP-proxy for item retrieved in previous step
  qa_header_token="'Authorization: bearer $et_token'"
  echo "*** et token is $qa_token"

  echo "******** calling QAttpProxyEndpoint $QAttpProxyEndpoint with body $body ********"
  qa_status_code=$(curl -s -o qaResponse.txt -w %{http_code} $QAttpProxyEndpoint --request POST --header "$qa_header_token" --data $body)

  if [ "$qa_status_code" -ne 200 ]; then
    echo "$qa_status_code Error received calling qa endpoint $QAttpProxyEndpoint Handling error and exiting !!!"
    # todo handle error - by writing a record to db?

    # end processing of request
    continue
  else
    qaBody=$(<qaResponse.txt)
    echo " *** Response returned from QA ttp endpoint is $qaBody"
  fi

  # post the response to the POST /response endpoint in the ET TTP-proxy endpoint
  #todo Replace below with et-ttp proxy endpoint
  ETttpProxyEndpoint2="http://localhost:9946/suppressions"
  echo "******** calling QAttpProxyEndpoint $ETttpProxyEndpoint2 with body $qaBody ********"

  et_status_code=$(curl -s -o qaResponse.txt -w %{http_code} $ETttpProxyEndpoint2 --request POST --header "$et_header_token" --data $qaBody)

  if [ "$et_status_code" -ne 200 ]; then
    echo "$et_status_code Error received calling qa endpoint $ETttpProxyEndpoint2 Handling error and exiting !!!"
    # todo handle error. Log error in db?

    # end processing of request
    continue
  else
    echo "*** Success! Response has been sent back to External Test***"
  fi

done
