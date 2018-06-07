#!/bin/bash

LOG_BACKUP=/root/vatic/data/backup.log
# dump all annotations
cd /root/vatic
turkic list|sed 's/ //g'|xargs -n 1 -i turkic dump {} --xml -o /root/vatic/data/xmls/{}.xml --dimensions 720x480  --merge --merge-threshold 0.5

# cat data/size_1984x1488.txt|xargs -n 1 -i turkic dump {} --xml -o /root/vatic/data/xmls/{}.xml --dimensions 1984x1488  --merge --merge-threshold 0.5
# cat data/size_1280x960.txt|xargs -n 1 -i turkic dump {} --xml -o /root/vatic/data/xmls/{}.xml --dimensions 1280x960  --merge --merge-threshold 0.5

# backup
# LOG_BACKUP=/root/vatic/data/backup.log
mysqldump -u root --databases vatic > data/vatic.mysql
date 

# restore
# if [ -f /root/vatic/data/db.mysql ];
# then
#     echo "Reading in previous database"
#     mysql -u root < /root/vatic/data/db.mysql
# fi