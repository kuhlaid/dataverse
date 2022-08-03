#!/bin/bash

# move things necessary for integration tests into build context.
# this was based off the phoenix deployment; and is likely uglier and bulkier than necessary in a perfect world
     
# commented out for testing
# sudo apt-get update                  # update the packages so `make` can be included
# sudo apt-get -y install make         # install `make` since it is not automatically included in the OS
# sudo apt-get -y install maven        # install `maven` since it is not automatically included in the OS

echo '------------------ start copy test data (/com.docker.devenvironments.code/conf/docker-aio/testdata)'                # testing
echo $(pwd)
mkdir -p testdata/doc/sphinx-guides/source/_static/util/
cd ../
echo $(pwd)
cp $(pwd)/solr/8.11.1/schema.xml docker-aio/testdata/
cp $(pwd)/solr/8.11.1/solrconfig.xml docker-aio/testdata/
cp $(pwd)/jhove/jhove.conf docker-aio/testdata/
cp $(pwd)/jhove/jhoveConfig.xsd docker-aio/testdata/
echo '------ end basic copy --------------'
cp -r scripts $(pwd)/docker-aio/testdata/
cd ../
cp doc/sphinx-guides/source/_static/util/createsequence.sql conf/docker-aio/testdata/doc/sphinx-guides/source/_static/util/
echo '------------------ end copy test data'                # testing

# wget -q https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
# tar xfz apache-maven-3.6.3-bin.tar.gz
# mkdir maven
# mv apache-maven-3.6.3/* maven/
# echo "export JAVA_HOME=/usr/lib/jvm/jre-openjdk" > maven/maven.sh
# echo "export M2_HOME=../maven" >> maven/maven.sh
# echo "export MAVEN_HOME=../maven" >> maven/maven.sh
# echo "export PATH=../maven/bin:${PATH}" >> maven/maven.sh
# chmod 0755 maven/maven.sh

# not using dvinstall.zip for setupIT.bash; but still used in install.bash for normal ops
# source maven/maven.sh && mvn clean
# ./scripts/installer/custom-build-number
# source maven/maven.sh && 
mvn package
cd scripts/installer
make clean
make
# mkdir -p ../../conf/docker-aio/dv/install
# cp dvinstall.zip ../../conf/docker-aio/dv/install/

# ITs sometimes need files server-side
# yes, these copies could be avoided by moving the build root here. but the build 
#  context is already big enough that it seems worth avoiding.
cd ../../
cp src/test/java/edu/harvard/iq/dataverse/makedatacount/sushi_sample_logs.json conf/docker-aio/testdata/
