#!/usr/bin/env bash

# Script to pass requests from TTP proxy on ET to the TTP proxy on QA, returning the responses back to ET.
# 1) Polls the ET stub db using the GET /requests endpoint to find next request.
# 2) Calls the QA TTP Proxy with the request from previous step.
# 3) Returns the response back to the ET TTP Proxy.
# 4) Deletes the request from the collection on ET so that it isn't processed again.
#
# If an error is found in any of the requests, the error will be written to the stub db errors table and processing of the request will end.

#todo Replace below with et-ttp proxy endpoint
ETttpStubEndpointRequests="http://localhost:10003/test-only/requests"
#ETttpStubEndpointResponse="http://localhost:10003/test-only/response" use this to write back to endpoint on stub
ETttpStubEndpointResponse="http://localhost:9600/test-only/response" # use this to write back to proxy directly
ETttpStubEndpointDelete="http://localhost:10003/test-only/request"
ETttpStubEndpointErrors="http://localhost:10003/test-only/errors"

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
  # ******* 1) Poll the ET stub db using the GET /requests endpoint to find next request. *******
  echo "******* START 1) Polling the ET stub db using the GET /requests endpoint to find next request. ******* "
  echo "********* calling external test ET proxy endpoint ${ETttpStubEndpointRequests} to check for requests *********"
  echo "********* et token is $et_token ********"

  et_header_token="'Authorization: Bearer $et_token'"
  curl -s -o -w %{http_code} $ETttpStubEndpointRequests --header "$et_header_token" | jq --raw-output "." | jq "." | sed -e 's/\\\"/\"/g' >et_response.txt
  body=$(<et_response.txt)

  if [[ "$body" != *"requestId"* ]]; then
    echo "Error received calling TTP proxy on ET $ETttpStubEndpointRequests Handling error and exiting !!!"
    # end processing of request
    continue
  else

#    No Error found. Set params then continue to next step to call QA
    requestId="$(echo ${body} | sed 's/\[.*requestId\": \"\(.*\)\", \"content.*/\1/')"
    content="$(echo ${body} | sed 's/\[.*content\": \"\(.*\)\", \"uri.*/\1/')"
    uri="$(echo ${body} | sed 's/\[.*uri\": \"\(.*\)\", \"isResponse.*/\1/')"
    QAuri="${QAttpProxyEndpoint}${uri}"

    echo "requestId variable is ^^^^^^^^" ${requestId}
    echo "content variable is ^^^^^^^^" ${content}
    echo "uri variable is ^^^^^^^^" ${uri}
    echo "QA uri variable is ^^^^^^^^" ${QAuri}

  fi

  # ********* 2) Call the QA TTP Proxy with the request from previous step. **********
  echo "********* 2) Call the QA TTP Proxy with the request from previous step. **********"

  # qa_header_token="'Authorization: Bearer $qa_token'" /// PUT BACK IN TO USE QA TOKEN
  qa_header_token="Authorization: Bearer BXQ3/Treo4kQCZvVcCqKPh0C0D0Bb0deK2KhU6/jjTu9J1ToD6lVf6J7k1JFpre1/ThCtxyCPrkJ/X3QeS+K8EvgilATFCckCXYBegW68PabFXEmdGzhBr/Zzmd92R9gdYfwEumthE1IuvgGKVLKf9pcHAr9oh7GMQ1pVeYWrln9KwIkeIPK/mMlBESjue4V"
  echo "*** qa header token is ${qa_header_token}"
  jsonToPost="${content}"
  echo "******** calling QAttpProxyEndpoint ${QAuri} with body from content ${jsonToPost} ********"

  qa_status_code=$(curl -s -o qaResponse.txt -w %{http_code} ${QAuri} --request POST -H "${qa_header_token}" -H "Content-Type: application/json" --data ${jsonToPost})

  if [ "$qa_status_code" != 200 ]; then
    echo "$qa_status_code Error received calling qa endpoint $QAuri Handling error and exiting !!!"

    #    Write error to stub error table
    et_error_db_status_code=$(curl -s -w %{http_code} ${ETttpStubEndpointErrors} --request POST -H "Content-Type: application/json" --data ${jsonToPost})
    if [ "${et_error_db_status_code}" != 200 ]; then
      echo "${et_error_db_status_code} Error when adding error to stub error db $ETttpStubEndpointErrors Exiting !!!"
      continue
    else
      echo "*** Written error to log 1***"
    fi

    # end processing of request
    continue
  else
    #    No Error found. Continue to next step to return response back to ET
    qa_response=$(<qaResponse.txt)
    sed 's/\"/\\\"/g' qaResponse.txt >qa_response_escaped.txt
    echo " *** Response returned from QA ttp endpoint is $qa_response"
    qa_response_escaped=$(<qa_response_escaped.txt)
    echo " *** Escaped response from QA ttp endpoint is ${qa_response_escaped}"
  fi

  # ******** 3) Return the response back to the ET TTP Proxy. ********
  echo "******** 3) Returning the response back to the ET TTP Proxy. *******"

  json_response_to_post_back_to_et="{\"requestId\": \"${requestId}\",\"content\": \"${qa_response_escaped}\",\"uri\": \"\",\"isResponse\": true}"
  echo "******** QA response content for sending to ET TTP Proxy is $qa_response ********"
  echo "******** calling ETttpStubEndpointResponse $ETttpStubEndpointResponse with body ${json_response_to_post_back_to_et} ********"

  et_status_code=$(curl -i -H "Content-Type: application/json" -o etPostResponse4.txt -w %{http_code} -X POST --data "${json_response_to_post_back_to_et}" ${ETttpStubEndpointResponse})
  echo "et_status_code isssdddd...$et_status_code"
  if [ "$et_status_code" != 200 ]; then
    echo "$et_status_code Error received posting response back to ET endpoint $ETttpStubEndpointResponse Exiting !!!"

    # Write error to stub error table
    et_error_db_status_code=$(curl -s -w %{http_code} ${ETttpStubEndpointErrors} --request POST -H "Content-Type: application/json" --data ${json_response_to_post_back_to_et})
    if [ "${et_error_db_status_code}" != 200 ]; then
      echo "${et_error_db_status_code} Error when adding error to stub error db ${ETttpStubEndpointErrors} Exiting !!!"
      continue
    else
      echo "*** Written error to log 2 ***"
    fi

    continue
  else
    echo "******* Success! Response has been sent back to External Test *******"
  fi

  # ******** 4) Delete the request from the collection on ET so that it isn't processed again. ********
  echo "******* 4) Deleting the request from the collection on ET so that it isn't processed again. ********"

  delete_uri="$ETttpStubEndpointDelete/$requestId"
  echo "delete_uri is.... $delete_uri"
  et_delete_status_code=$(curl -i -H "Content-Type: application/json" -w %{http_code} -X DELETE ${delete_uri})
  echo "et_delete_status_code is...$et_delete_status_code"

  if [[ "$et_delete_status_code" != *"200" ]]; then
    echo "$et_delete_status_code Error received deleting the request from the ET endpoint ${delete_uri} Exiting !!!"
    continue
  else
    echo "*** Success! Request has been deleted. END ***"
  fi

done
