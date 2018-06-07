#!/bin/bash

echo "start mysql"
/etc/init.d/mysql start
echo "start apache"
apache2ctl start