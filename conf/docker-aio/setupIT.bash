#!/usr/bin/env bash

# do integration-test install and test data setup

# the dv and testdata directories are initially stored under `/conf/docker-aio`
cd /opt/dv
unzip dvinstall.zip
cd /opt/dv/testdata
./scripts/deploy/phoenix.dataverse.org/prep
./db.sh
./install # modified from phoenix
/usr/local/glassfish4/glassfish/bin/asadmin deploy /opt/dv/dvinstall/dataverse.war
./post # modified from phoenix

