# Setup in Docker Desktop

Trying to create a dev environment within Docker Desktop by trying to load from (NOTE: do not try to setup dev environment using local code directory because Docker will not pick up the laguage type Java):  
`https://github.com/kuhlaid/dataverse.git`

Once the container is loaded, navigate into the container and choose the Docker CLI for the container. Then enter:
`cd com.docker.devenvironments.code`

From here we will follow the steps laided out in `https://github.com/IQSS/dataverse/tree/develop/conf/docker-ubuntu` under QuickStart
`./conf/docker-ubuntu/prep_it.bash`





From here we will follow the steps laided out in `https://github.com/IQSS/dataverse/tree/develop/conf/docker-aio` under QuickStart
`./conf/docker-aio/prep_it.bash`

cp /com.docker.devenvironments.code/conf/solr/8.8.1/solrconfig.xml /com.docker.devenvironments.code/conf/testdata/

Then we need to check the Path to make sure Maven was included
`echo $PATH`
`mvn -version`
`printenv`   // print all env variables
`whereis solr`      // search for Solr directories

apt list "post*" 2>/dev/null |awk -F'/' 'NR>1{print $1}'

`SOLR_HOME="/usr/share/solr"`
`export SOLR_HOME`

`SOLR_HOME=$(whereis solr | awk '{print $3}')`      // sets SOLR_HOME TO `/usr/share/solr`

`SOLR_HOME=$(whereis solr | awk '{print $2}')`      // sets SOLR_HOME TO `/etc/solr`


## ISSUES WITH DOCKER BUILD

- on https://github.com/kuhlaid/dataverse/edit/develop/conf/docker-aio/0prep_deps.sh
the wdir=`pwd` is never used and 
- the dv/deps directory should be used for the dvinstaller
- unzip:  cannot find or open dvinstall.zip (on build scripts); feel like the install directory needs to be set differently in https://github.com/IQSS/dataverse/blob/3c616d2c386a63e7b60e585a29f11c9f14478d0b/scripts/installer/Makefile
- conf/docker-aio/setupIT.bash is expecting the `dvinstall.zip` file under /opt/dv; the conf/docker-aio/install.bash is expecting the `dvinstall.zip` file under




CloudApps build (did not complete due to out of memory error)

This works (at least to pull the data from Git, but likely needs an environment file)
```bash
oc new-app openjdk-11:latest~"https://github.com/kuhlaid/dataverse.git" \
--name dataverse-git
```

Delete the Dataverse build
`oc delete all --selector app=dataverse-git`