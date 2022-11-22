#!/bin/sh

full=$(DOCUMENT_URI=/api/$SERVICE_PREFIX/healthz SCRIPT_FILENAME=/app/src/index.php REQUEST_METHOD=GET cgi-fcgi -bind -connect /run/php-fpm/php.sock)

before=${full%$'\r\n\r\n'*}
after=${full#*$'\r\n\r\n'}
stat=$(echo $before | sed 's/.*Status: //' | cut -d " " -f 1)
sub="Status:"

if $(echo "$before" | grep -q "$sub"); then
  if [ "$stat" != "200" ]; then
  exit 1
  fi
fi

if [[ "$after" != "OK" ]]; then
  exit 1
fi

exit
