#!/usr/bin/env bash

# script to poll the GET /requests endpoint in the ET TTP-proxy,
# call the qa ttp endpoint and then return the response back to ET
#Delete the request from the collection on ET
# If an error is found in any of the requests, processing of the request will end.

#todo Replace below with et-ttp proxy endpoint
ETttpStubEndpoint="http://localhost:10003/test-only/requests"
ETttpStubEndpointResponse="http://localhost:10003/test-only/response"

#todo Replace below with qa-ttp proxy endpoint
QAttpProxyEndpoint="http://localhost:9600/"

ETTokenEndpoint="https://test-api.service.hmrc.gov.uk/oauth/token"
QATokenEndpoint="http://localhost:8585/government-gateway/session/login"

# Get token for external test
token_body="client_secret=8ac71009-56c6-4898-b29b-4e5ca95776b8&client_id=zW01C9PlZBhuClygEWTcjTymEibX&grant_type=client_credentials&expires_in=500000 &scope=read:time-to-pay-proxy" # todo update when ttp service has been deployed
et_token_json=$(curl -s -o token_response.txt -w %{http_code} --request POST --header "content-type: application/x-www-form-urlencoded" --data $token_body $ETTokenEndpoint)
et_token=$(echo $et_token_json | cut -d'"' -f 4)

# Get token for qa
token_body="client_secret=6c2fc716-b9c6-4bb8-a57e-4908d32b9b27&client_id=reRg5ZSks9hGLpzxS5RRnYHjHYtW&grant_type=client_credentials&expires_in=500000 &scope=read:time-to-pay-proxy" # todo update when ttp service has been deployed to qa
qa_token_json=$(curl -s -o qa_token_response.txt -w %{http_code} --request POST --header "content-type: application/json" --data $token_body $QATokenEndpoint)
qa_token=$(echo $qa_token_json | cut -d'"' -f 4)
echo "*** qa token json is $qa_token_json"
echo "*** qa token is $qa_token"

for (( ; ; )); do
  sleep 2
  # Call ET Proxy Endpoint
  echo "********* calling external test ET proxy endpoint ${ETttpStubEndpoint} to check for requests *********"
  echo "********* et token is $et_token ********"
  et_header_token="'Authorization: Bearer $et_token'"
  curl -s -o -w %{http_code} $ETttpStubEndpoint --header "$et_header_token" | jq --raw-output "." | jq "." | sed -e 's/\\\"/\"/g' >et_response.txt
  body=$(<et_response.txt)

  if [[ "$body" != *"requestId"* ]]; then
    echo "Error received calling TTP proxy on ET $ETttpStubEndpoint Handling error and exiting !!!"
    # todo handle error - by writing a record to db?

    # end processing of request
    continue
  else
    requestId="$(echo ${body} | sed 's/\[.*requestId\": \"\(.*\)\", \"content.*/\1/')"
    content="$(echo ${body} | sed 's/\[.*content\": \"\(.*\)\", \"uri.*/\1/')"
    uri="$(echo ${body} | sed 's/\[.*uri\": \"\(.*\)\", \"isResponse.*/\1/')"
    QAuri="${QAttpProxyEndpoint}${uri}"

    echo "requestId variable is ^^^^^^^^" ${requestId}
    echo "content variable is ^^^^^^^^" ${content}
    echo "uri variable is ^^^^^^^^" ${uri}
    echo "QA uri variable is ^^^^^^^^" ${QAuri}

  fi

  #make a call to the QA TTP-proxy for item retrieved in previous step
  #  qa_header_token="'Authorization: Bearer $qa_token'" /// PUT BACK IN TO USE QA TOKEN
  qa_header_token="Authorization: Bearer BXQ3/Treo4kQCZvVcCqKPoK4niRXfUHbxlMD2TduCU0zPGucGPBzEp3nrqqDpXkIKahgkCpNDD/UTLi1UY0ex2vPcfdf6jaqv8jyOh0YcXETTkIPupvzom0x5fksGULDvxAcpYYUR7dFAIjj+2Ryu9Js9jtArfM+A3ZsvFQRZ0b9KwIkeIPK/mMlBESjue4V"
  echo "*** qa header token is ${qa_header_token}"
  jsonToPost="${content}"

  echo "******** calling QAttpProxyEndpoint ${QAuri} with body from content ${jsonToPost} ********"
  qa_status_code=$(curl -s -o qaResponse.txt -w %{http_code} ${QAuri} --request POST -H "${qa_header_token}" -H "Content-Type: application/json" --data ${jsonToPost})

  if [ "$qa_status_code" != 200 ]; then
    echo "$qa_status_code Error received calling qa endpoint $QAuri Handling error and exiting !!!"
    # todo handle error - by writing a record to db?
    sleep 5

    # end processing of request
    continue
  else
    qa_response=$(<qaResponse.txt)
    sed 's/\"/\\\"/g' qaResponse.txt >qa_response_escaped.txt
    #    qa_response_escaped=sed -i 's/"/\"/g' kdd.txt
    echo " *** Response returned from QA ttp endpoint is $qa_response"
    qa_response_escaped=$(<qa_response_escaped.txt)
    echo " *** Escaped response from QA ttp endpoint is ${qa_response_escaped}"
  fi

  # post the response to the POST /response endpoint in the ET TTP-proxy endpoint

  json_response_to_post_back_to_et="{\"requestId\": \"${requestId}\",\"content\": \"${qa_response_escaped}\",\"uri\": \"\",\"isResponse\": true,\"processed\": true}"
  echo "******** QA response content for sending to ET is $qa_response ********"
  echo "******** calling ETttpStubEndpointResponse $ETttpStubEndpointResponse with body ${json_response_to_post_back_to_et} ********"

  et_status_code=$(curl -i -H "Content-Type: application/json" -o etPostResponse4.txt -w %{http_code} -X POST --data "${json_response_to_post_back_to_et}" ${ETttpStubEndpointResponse})

  if [ "$et_status_code" != 200 ]; then
    echo "$et_status_code Error received posting response back to ET endpoint $ETttpStubEndpointResponse Exiting !!!"
    # todo handle error. Log error in db?

    continue
  else
    echo "*** Success! Response has been sent back to External Test***"
  fi

  Delete the request

  et_delete_status_code=$(curl -i -H "Content-Type: application/json" -w %{http_code} -X DELETE ${ETttpStubEndpointResponse})

  if [ "$et_delete_status_code" != 200 ]; then
    echo "$et_delete_status_code Error received deleting the request from the ET endpoint $ETttpStubEndpointResponse Exiting !!!"
    continue
  else
    echo "*** Success! Request has been deleted ***"
  fi

done
