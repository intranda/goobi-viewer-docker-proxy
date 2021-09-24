#!/bin/bash
set -e

echo -e "$SOLR_INCLUDES" >/usr/local/apache2/conf/solr-restrictions.conf
envsubst '\$HTTPD_PORT \$SERVERNAME \$SERVERADMIN \$VIEWER_HTTP_PORT \$VIEWER_AJP_PORT \$VIEWER_PATH \$VIEWER_CONTAINER \$CONNECTOR_AJP_PORT \$CONNECTOR_PATH \$CONNECTOR_CONTAINER \$SOLR_PORT \$SOLR_PATH \$SOLR_CONTAINER' < /usr/local/apache2/conf/httpd.conf.template > /usr/local/apache2/conf/httpd.conf

echo "Starting Apache2..."
exec httpd-foreground