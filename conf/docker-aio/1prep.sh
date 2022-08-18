#!/bin/bash

# we need to install Docker first
apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# apt-get update
# apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# adding nano just to have a text editor for testing
apt-get update && apt-get install -y default-jre make nano zip docker-ce docker-ce-cli containerd.io docker-compose-plugin

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

wget https://downloads.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
tar xfz apache-maven-3.8.6-bin.tar.gz
mkdir maven
mv apache-maven-3.8.6/* maven/
# this should automatically read the jvm directory to set JAVA_HOME (which is somewhere like: /usr/lib/jvm/java-11-openjdk-amd64)
echo "export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:/bin/java::")" > maven/maven.sh
echo "export M2_HOME=$(pwd)/maven" >> maven/maven.sh
echo "export MAVEN_HOME=$(pwd)/maven" >> maven/maven.sh
echo "export PATH=$(pwd)/maven/bin:${PATH}" >> maven/maven.sh
chmod 0755 maven/maven.sh

# not using dvinstall.zip for setupIT.bash; but still used in install.bash for normal ops
source maven/maven.sh && mvn clean
./scripts/installer/custom-build-number
source maven/maven.sh && mvn package
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
