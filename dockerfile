FROM remcam/postgres
MAINTAINER svanschalkwyk <step@remcam.net>

ENV MANIFOLDCF_VERSION 2.2
ENV MANIFOLD_GZIP     apache-manifoldcf-$MANIFOLDCF_VERSION-bin.tar.gz
ENV MANIFOLD_LIB_GZIP apache-manifoldcf-$MANIFOLDCF_VERSION-lib.tar.gz
ENV MANIFOLD_JCIFS_VERSION 1.3.18
ENV MANIFOLD_JCIFS_GZIP jcifs-$MANIFOLD_JCIFS_VERSION.tgz

RUN export DEBIAN_FRONTEND=noninteractive 
#RUN apt-get update && apt-get install -y wget

#RUN	wget -nv -O /tmp/$MANIFOLD_GZIP http://www.us.apache.org/dist/manifoldcf/apache-manifoldcf-$MANIFOLDCF_VERSION/$MANIFOLD_GZIP  
#RUN	wget -nv -O /tmp/$MANIFOLD_GZIP/lib http://www.us.apache.org/dist/manifoldcf/apache-manifoldcf-$MANIFOLDCF_VERSION/$MANIFOLD_LIB_GZIP  
#RUN	rm /tmp/apache-manifoldcf-$MANIFOLDCF_VERSION/lib/$MANIFOLD_LIB_GZIP
	
RUN 	mkdir /tmp/apache-manifoldcf-$MANIFOLDCF_VERSION
COPY	$MANIFOLD_GZIP /tmp/
RUN	tar zxvf /tmp/$MANIFOLD_GZIP -C /tmp/apache-manifoldcf-$MANIFOLDCF_VERSION --strip-components=1
RUN     rm /tmp/$MANIFOLD_GZIP

COPY 	$MANIFOLD_LIB_GZIP /tmp/
RUN 	tar zxvf /tmp/$MANIFOLD_LIB_GZIP -C /tmp/apache-manifoldcf-$MANIFOLDCF_VERSION/lib --strip-components=1
#RUN	rm /tmp/$MANIFOLD_LIB_GZIP

COPY	$MANIFOLD_JCIFS_GZIP /tmp/
RUN 	tar zxvf /tmp/$MANIFOLD_JCIFS_GZIP -C /tmp/apache-manifoldcf-$MANIFOLDCF_VERSION/lib-proprietary --strip-components=1
#RUN 	rm /tmp/jcifs-$MANIFOLD_JCIFS_VERSION.tgz

RUN  	mv /tmp/apache-manifoldcf-$MANIFOLDCF_VERSION/ /opt/manifoldcf/

#RUN  rm -r /tmp/$MANIFOLD_GZIP
#RUN	apt-get update 

WORKDIR /opt/manifoldcf
RUN rm -rf doc &&\
    rm -rf test-lib &&\
    rm -rf multiprocess-file-example &&\
    rm -rf multiprocess-zk-example &&\
    rm -rf script-engine &&\
    rm -rf documentum-registry-process &&\
    rm -rf documentum-server-process &&\
    rm -rf elasticsearch-integration &&\
    rm -rf lib-proprietary &&\
    rm -rf meridio-integration &&\
    rm -rf sharepoint-integration &&\
    rm -rf solr-integration &&\
    rm -rf filenet-registry-process &&\
    rm -rf filenet-server-process &&\
    rm connector-lib-proprietary/* &&\
    rm connector-build.xml &&\
    rm NOTICE.txt &&\
    rm README.txt &&\
    rm DEPENDENCIES.txt &&\
    mv example bin &&\
    rm bin/*.bat &&\
    rm bin/combined-options.env.win &&\
    mv bin/start-combined.sh bin/start.sh &&\
    rm bin/properties.xml &&\
    rm connectors.xml &&\
    chmod +x bin/start.sh

COPY connectors.xml /opt/manifoldcf/
COPY jetty.xml /opt/manifoldcf/bin/
COPY properties.xml /opt/manifoldcf/bin/

WORKDIR /opt/manifoldcf/bin

CMD ["/opt/manifoldcf/bin/start.sh"]

EXPOSE 8345

