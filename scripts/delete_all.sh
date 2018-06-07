#!/bin/bash

# dump all annotations
cd /root/vatic
turkic list|sed 's/ //g'|xargs -n 1 -i turkic delete {} --force
rm ./data/xmls/*
rm ./data/htmls/*
rm ./data/links/*
turkic setup --database --reset


# backup
# mysqldump -u root --all-databases > data/db.mysql

# restore
# if [ -f /root/vatic/data/db.mysql ];
# then
#     echo "Reading in previous database"
#     mysql -u root < /root/vatic/data/db.mysql
# fi