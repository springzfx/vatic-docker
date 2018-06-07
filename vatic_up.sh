#!/bin/bash

## stop vatic container
# docker stop vatic
## remove vatic contaioner, it's a  bad idea
# docker rm $(docker ps -lqf name=^/vatic$)

## find old vatic contaioner
# OLD_CID=`docker ps -lqf name=^/vatic$`
# echo $OLD_CID
# if [ $OLD_CID ];
# then
# 	echo "start old vatic container"
# 	docker start  $OLD_CID
# 	exit
# else
# 	echo "create new vatic container"
# fi


docker run -itd --rm \
				--name autonomous_vatic \
				-p 8888:80 \
				-v "/etc/localtime:/etc/localtime:ro" \
				-v "$PWD/data":/root/vatic/data \
                -v "$PWD/scripts":/root/vatic/scripts \
                -v vatic-docker-mysql:/var/lib/mysql \
                autonomous/vatic-docker:latest /bin/bash -C /root/vatic/scripts/entry.sh

PORT=$(docker port autonomous_vatic 80 | awk -F: '{ print $2 }')
echo "Point brower to http://localhost:$PORT/htmls"

# docker attach $JOB
# docker exec -it $JOB /bin/bash
