#!/bin/sh
# download necessary dependencies and setup necessary directories

if [ ! -d dv/deps ]; then
	mkdir -p dv/deps
fi

# need these for the Dockerfile
if [ ! -d /opt/dv ]; then
	sudo mkdir -p /opt/dv
fi
if [ ! -d /tmp/dv ]; then
	mkdir -p /tmp/dv
fi

if [ ! -e dv/deps/payara-5.2021.6.zip ]; then
	echo "payara dependency prep"
	wget https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/5.2021.6/payara-5.2021.6.zip  -O dv/deps/payara-5.2021.6.zip
fi

if [ ! -e dv/deps/solr-8.11.1dv.tgz ]; then
	echo "solr dependency prep"	
	wget https://archive.apache.org/dist/lucene/solr/8.11.1/solr-8.11.1.tgz -O dv/deps/solr-8.11.1dv.tgz
fi
