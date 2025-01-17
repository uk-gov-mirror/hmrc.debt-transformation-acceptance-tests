#!/usr/bin/env bash

environment="local"
tags="not @wip and not @ignore"
if [ $# -gt 0 -a "$1" != "$environment" ];
then
  environment="$1"
  tags="not @wip and not @ignore"
fi

echo "*** running on $environment for tags '$tags' ***"

sbt -Denvironment="$environment" -Dcucumber.options="--tags '$tags'" clean 'testOnly uk.gov.hmrc.test.api.cucumber.runner.InterestForecastingApiTestRunner'