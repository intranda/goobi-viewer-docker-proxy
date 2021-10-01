#!/bin/bash
set -e

echo -e "$SOLR_INCLUDES" >/usr/local/apache2/conf/solr-restrictions.conf
envsubst '\$HTTPD_PORT \$SERVERNAME \$SERVERADMIN \$REMOTEIP_HEADER \$REMOTEIP_INTERNAL_PROXY \$VIEWER_HTTP_PORT \$VIEWER_AJP_PORT \$VIEWER_PATH \$VIEWER_CONTAINER \$CONNECTOR_AJP_PORT \$CONNECTOR_HTTP_PORT \$CONNECTOR_PATH \$CONNECTOR_CONTAINER \$SOLR_PORT \$SOLR_PATH \$SOLR_CONTAINER' < /usr/local/apache2/conf/httpd.conf.template > /usr/local/apache2/conf/httpd.conf

if [ $USE_MOD_REMOTEIP -eq 1 ]
then
   echo "Enabling mod_remoteip"
   sed -i 's|#LoadModule remoteip_module modules/mod_remoteip.so|LoadModule remoteip_module modules/mod_remoteip.so|' /usr/local/apache2/conf/httpd.conf
fi

if [[ "$SITEMAP_LOCATION" != "" ]]
then
   echo "Setting Sitemap in robots.txt"
   sed -i -E "s|^.?Sitemap:.*$|Sitemap: $SITEMAP_LOCATION|" /var/www/robots.txt
fi

echo "Starting Apache2..."
exec httpd-foreground