FROM rockylinux/rockylinux:latest
# OS dependencies
RUN yum install -y java-11-openjdk-devel postgresql-server sudo epel-release unzip curl httpd
RUN yum install -y jq lsof awscli

# copy and unpack dependencies (solr, payara)
# RUN sudo cp dv /tmp/dv
# RUN sudo cp testdata/schema*.xml /tmp/dv/
# RUN sudo cp testdata/solrconfig.xml /tmp/dv

# ITs need files
# RUN sudo cp testdata/sushi_sample_logs.json /tmp/

# IPv6 and localhost appears to be related to some of the intermittant connection issues
COPY  disableipv6.conf /etc/sysctl.d/
RUN rm /etc/httpd/conf/*
COPY httpd.conf /etc/httpd/conf 
RUN cd /opt ; tar zxf /tmp/dv/deps/solr-8.11.1dv.tgz 
RUN cd /opt ; unzip /tmp/dv/deps/payara-5.2020.6.zip ; ln -s /opt/payara5 /opt/glassfish4

# this copy of domain.xml is the result of running `asadmin set server.monitoring-service.module-monitoring-levels.jvm=LOW` on a default glassfish installation (aka - enable the glassfish REST monitir endpoint for the jvm`
# this dies under Java 11, do we keep it?
#COPY domain-restmonitor.xml /opt/payara5/glassfish/domains/domain1/config/domain.xml

RUN sudo -u postgres /usr/bin/initdb /var/lib/pgsql/data

# copy configuration related files
# RUN sudo cp /tmp/dv/pg_hba.conf /var/lib/pgsql/data/
# RUN sudo cp -r /opt/solr-8.11.1/server/solr/configsets/_default /opt/solr-8.11.1/server/solr/collection1
# RUN sudo cp /tmp/dv/schema*.xml /opt/solr-8.11.1/server/solr/collection1/conf/
# RUN sudo cp /tmp/dv/solrconfig.xml /opt/solr-8.11.1/server/solr/collection1/conf/solrconfig.xml

# skipping payara user and solr user (run both as root)

#solr port
EXPOSE 8983

# postgres port
EXPOSE 5432

# payara port
EXPOSE 8080

# apache port, http
EXPOSE 80

# debugger ports (jmx,jdb)
EXPOSE 8686
EXPOSE 9009

# RUN mkdir /opt/dv

# keeping the symlink on the off chance that something else is still assuming /usr/local/glassfish4
# RUN ln -s /opt/payara5 /usr/local/glassfish4
# RUN sudo cp dv/install/ /opt/dv/
# RUN sudo cp install.bash /opt/dv/
# RUN sudo cp entrypoint.bash /opt/dv/
# RUN sudo cp testdata/* /opt/dv/testdata
# RUN sudo cp testscripts/* /opt/dv/testdata/
# RUN sudo cp setupIT.bash /opt/dv
WORKDIR /opt/dv

# need to take DOI provider info from build args as of ec377d2a4e27424db8815c55ce544deee48fc5e0
# Default to EZID; use built-args to switch to DataCite (or potentially handles)
#ARG DoiProvider=EZID
ARG DoiProvider=FAKE
ARG doi_baseurl=https://ezid.cdlib.org
ARG doi_username=apitest
ARG doi_password=apitest
ENV DoiProvider=${DoiProvider}
ENV doi_baseurl=${doi_baseurl}
ENV doi_username=${doi_username}
ENV doi_password=${doi_password}
# RUN sudo cp configure_doi.bash /opt/dv

# healthcheck for payara only (assumes modified domain.xml);
#  does not check dataverse application status.
HEALTHCHECK CMD curl --fail http://localhost:4848/monitoring/domain/server.json || exit 1
CMD ["/opt/dv/entrypoint.bash"]
