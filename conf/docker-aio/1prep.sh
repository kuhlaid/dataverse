#!/bin/bash

apt-get update && apt-get install -y \
    java-11-openjdk-devel \
    make \
    zip

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
echo "export JAVA_HOME=/usr/lib/jvm/jre-openjdk" > maven/maven.sh
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
