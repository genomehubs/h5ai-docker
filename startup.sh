#!/bin/bash

if [ -s /conf/lighttpd.conf ]; then
  cp /conf/lighttpd.conf /lighttpd/conf/
fi

if [ -s /conf/options.json ]; then
  cp /conf/options.json /var/www/html/_h5ai/private/conf/
fi

if [ -s /conf/index.html ]; then
  cp /conf/index.html /var/www/html/
fi

if [ -s /conf/_h5ai.headers.html ]; then
  cp /conf/_h5ai.headers.html /var/www/html/
fi

if [ -s /conf/_h5ai.footers.html ]; then
  cp /conf/_h5ai.footers.html /var/www/html/
fi

if [ -s /conf/Masthead.html ]; then
#  sed -i '/<body[^>]*>/ r /conf/Masthead.html' /var/www/html/_h5ai/private/php/pages/index.php
  sed -i 's:</head>:</head>\n:' /var/www/html/_h5ai/private/php/pages/index.php
  sed -i '/<\/head>/ r /conf/Masthead.html' /var/www/html/_h5ai/private/php/pages/index.php
  sed -i 's:<body[^>]*>:<outer class="index" id="root">:' /var/www/html/_h5ai/private/php/pages/index.php
  sed -i 's:</head>:</head><body>:' /var/www/html/_h5ai/private/php/pages/index.php
  sed -i 's:</body>:</outer></body>:' /var/www/html/_h5ai/private/php/pages/index.php
  sed -i 's:o="body":o="outer":g' /var/www/html/_h5ai/public/js/scripts.js
fi

if [ -d /conf/img ]; then
  mkdir /var/www/html/img
  cp /conf/img/* /var/www/html/img/
fi

if [ -s /conf/custom.css ]; then
  cp /conf/custom.css /var/www/html/_h5ai/public/ext/
  sed -i "s/\"styles\": \[/ \"styles\": \[ \"custom.css\",/" /var/www/html/_h5ai/private/conf/options.json
fi

if [ -s /conf/colors.less ]; then
  cp /conf/colors.less /var/www/html/_h5ai/public/css/lib/
fi

rm -f /var/www/html/index.lighttpd.html

/lighttpd/sbin/lighttpd -f /lighttpd/conf/lighttpd.conf
tail -f /dev/null
