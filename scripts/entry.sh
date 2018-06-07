#!/bin/bash

# Settings
cd /root/vatic/

# Start database and server
echo "start up"
service apache2 start
service mysql start

echo "check database"
turkic setup --database

# # restore
# if [ -f /root/vatic/data/db.mysql ];
# then
#     echo "Reading in previous database"
#     mysql -u root < /root/vatic/data/vatic.mysql
# fi

bash ./scripts/load_video.sh

ln -sf /root/vatic/data/htmls /root/vatic/public/
ln -sf /root/vatic/data/xmls /root/vatic/public/ 

# crontab, backup database every 10m
# cron start
# crontab /root/vatic/scripts/root && echo "crontab backup startup"

# open up a bash shell on the server
/bin/bash
