#!/bin/sh

log=ct-log.md
tf=/tmp/ctget$$.txt

curl "https://crt.sh/?q=\.onion" |
    perl -nle 'next unless m!TD.*\.onion\b!; s!\s+!\n!go; s!</?TD>!\n!goi; s!<BR>!\n!goi; print' |
    egrep '[2-7a-z]{56}\.onion$' |
    sort -u |
    awk -F. '{print $(NF-1), $0}' |
    sort |
    awk 'BEGIN {print "# Onion Certificate Transparency Log"} $2~/^\*/{print "* *wildcard* `" $2 "`"; next} {url = "https://" $2; printf("* [`%s`](%s)\n",url,url)}' >$tf

test -s $tf && cp $tf $log
rm $tf

exit 0
