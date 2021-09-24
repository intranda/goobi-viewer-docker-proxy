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
ENV SOLR_INCLUDES "Require all denied"

COPY httpd.conf.template /usr/local/apache2/conf/httpd.conf.template
COPY run.sh /
RUN apt-get update && apt-get -y upgrade && apt-get -y install gettext-base && rm -rf /var/lib/apt/lists/*
RUN mkdir /var/www && touch /var/www/index.html

CMD ["/run.sh"]