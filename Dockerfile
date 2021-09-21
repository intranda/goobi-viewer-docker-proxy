FROM httpd:2.4 

LABEL org.opencontainers.image.authors="Matthias Geerdsen <matthias.geerdsen@intranda.com>"


ENV HTTPD_PORT 80
ENV SERVERNAME localhost
ENV SERVERADMIN support@intranda.com

ENV VIEWER_HTTP_PORT 8080
ENV VIEWER_AJP_PORT 8009
ENV VIEWER_PATH /viewer
ENV VIEWER_CONTAINER viewer

ENV CONNECTOR_AJP_PORT 8009
ENV CONNECTOR_PATH /M2M
ENV CONNECTOR_CONTAINER connector

ENV SOLR_PORT 8983
ENV SOLR_PATH /solr
ENV SOLR_CONTAINER solr

COPY httpd.conf.template /usr/local/apache2/conf/httpd.conf.template
RUN apt-get update && apt-get -y upgrade && apt-get -y install gettext-base && rm -rf /var/lib/apt/lists/*
RUN mkdir /var/www && touch /var/www/index.html
CMD /bin/bash -c "envsubst '\$HTTPD_PORT \$SERVERNAME \$SERVERADMIN \$VIEWER_HTTP_PORT \$VIEWER_AJP_PORT \$VIEWER_PATH \$VIEWER_CONTAINER \$CONNECTOR_AJP_PORT \$CONNECTOR_PATH \$CONNECTOR_CONTAINER \$SOLR_PORT \$SOLR_PATH \$SOLR_CONTAINER' < /usr/local/apache2/conf/httpd.conf.template > /usr/local/apache2/conf/httpd.conf" && cat /usr/local/apache2/conf/httpd.conf && httpd-foreground