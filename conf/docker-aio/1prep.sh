#!/bin/bash

# move things necessary for integration tests into build context.
# this was based off the phoenix deployment; and is likely uglier and bulkier than necessary in a perfect world
dnf -y update                  # update the packages so `make` can be included
dnf -y install make         # install `make` since it is not automatically included in the OS
dnf -y install maven 

mkdir -p testdata/doc/sphinx-guides/source/_static/util/
cd ../
cp $(pwd)/solr/8.11.1/schema.xml docker-aio/testdata/
cp $(pwd)/solr/8.11.1/solrconfig.xml docker-aio/testdata/
cp $(pwd)/jhove/jhove.conf docker-aio/testdata/
cp $(pwd)/jhove/jhoveConfig.xsd docker-aio/testdata/
cd ../
cp -r $(pwd)/scripts $(pwd)/conf/docker-aio/testdata/
cp doc/sphinx-guides/source/_static/util/createsequence.sql conf/docker-aio/testdata/doc/sphinx-guides/source/_static/util/
echo $(pwd)

# wget https://downloads.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
# tar xfz apache-maven-3.8.6-bin.tar.gz
# mkdir maven
# mv apache-maven-3.8.6/* maven/
# echo "export JAVA_HOME=/usr/lib/jvm/jre-openjdk" > maven/maven.sh
# echo "export M2_HOME=../maven" >> maven/maven.sh
# echo "export MAVEN_HOME=../maven" >> maven/maven.sh
# echo "export PATH=../maven/bin:${PATH}" >> maven/maven.sh
# chmod 0755 maven/maven.sh

# not using dvinstall.zip for setupIT.bash; but still used in install.bash for normal ops
# source maven/maven.sh && mvn clean
# ./scripts/installer/custom-build-number
# source maven/maven.sh && mvn package
# mvn clean
# dnf -y update     # update again just in case
rm -rf rm -rf ~/.m2/repository/org/apache/      # hopefully clears this issue (https://stackoverflow.com/questions/17223536/failed-to-execute-goal-org-apache-maven-pluginsmaven-compiler-plugin2-3-2comp)
mvn clean compile
cd scripts/installer
make clean
make
mkdir -p ../../conf/docker-aio/dv/install
cp dvinstall.zip ../../conf/docker-aio/dv/install/

# ITs sometimes need files server-side
# yes, these copies could be avoided by moving the build root here. but the build 
#  context is already big enough that it seems worth avoiding.
cd ../../
cp src/test/java/edu/harvard/iq/dataverse/makedatacount/sushi_sample_logs.json conf/docker-aio/testdata/
