# Changelog

All notable changes to this section of the project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.1] - things needing to be fixed (2022.08.02)

- [ ] create a docker-aio-ubuntu directory for building a fresh docker image
- [ ] switch to using Ubuntu for Docker build instead of RockyLinux since it does not include a lot of items needed for the build
- [-] need to try and install Postgres to `/opt` directory (need to download from URL since ***RockyLinux will not pull from any repositories using YUM*** so we need to install using apt-get or pull archive files from a hard-coded URL)
- [ ] need to make directories for `/tmp/dv` and `/opt/dv` so Docker can copie files to them
- [ ] the DockerFile and `conf/docker-aio/setupIT.bash` reference code copied to `/opt/dv` which is where the final Dataverse run scripts will go, so make sure the files are copied there
- [-] moved from CentOs since End of Life (EOL) for CentOS 8 – December 31st, 2021; switched to RockyLinux (did not work so well)
- [x] get Maven installed (NOTE: this increases the Docker build time but this is normal since it is downloading and installing Maven, Payara; also the )
- [ ] removing hard coded Solr directories in [/conf/docker-aio/c8.dockerfile](/conf/docker-aio/c8.dockerfile)
- [ ] can probably remove the Payara and Solr downloads (and the dataverse/conf/docker-aio/0prep_deps.sh script) which may be included when we run the Maven install??; commenting out 0prep_deps.sh and updating the c8.dockerfile to ignore the Payara and Solr files that were not downloaded from 0prep_deps.sh
- [ ] unzip:  cannot find or open dvinstall.zip (on build scripts); feel the install directory needs to be set differently in [/scripts/installer/Makefile](/scripts/installer/Makefile)
- [ ] saving `dvinstall.zip` to `/scripts/installer/` along with the payara and solr zip files; `conf/docker-aio/setupIT.bash` is expecting the `dvinstall.zip` file under `/opt/dv`; `conf/docker-aio/install.bash` is expecting the `dvinstall.zip` file under `conf/docker-aio`;  `dataverse/conf/docker-aio/1prep.sh` seems to be trying to save the `dvinstall.zip` file to `../../conf/docker-aio/dv/install`; `/.gitignore` is expecting `dvinstall.zip` under `scripts/installer/dvinstall.zip`
- [ ] the references to specific versions of Maven (such as [https://downloads.apache.org/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz]) should probably be set in a configuration file and a script created that checks that versions of the files are accessible first thing to ensure all proper resources are available for the Docker build
- [ ] search for `dvinstall` and fix references in the documentation and other
- [ ] create an automated build check workflow in Git
- [x] do not install OpenJdk to `/usr/jdk` since it needs root permissions; fixing the path to the java install directory
- [x] dataverse/conf/docker-aio/ needs a CHANGELOG.md
