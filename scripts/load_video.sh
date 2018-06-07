#!/bin/bash

# load videos in specific directory

set -e
cd /root/vatic/

TODOVIDEOPATH=/root/vatic/data/videos_in
DONEVIDEOPATH=/root/vatic/data/videos_out
FRAMEPATH=/root/vatic/data/frames_in
LINKPATH=/root/vatic/data/links
HTMLPATH=/root/vatic/data/htmls
LOG_STARTUP=/root/vatic/data/startup.log

TURKOPS="--offline"



# check label file
LABEL_FILE=/root/vatic/data/labels.txt
if [ -f "$LABEL_FILE" ]
then
    LABELS=`cat $LABEL_FILE | tr "\n" " "`
    echo "Labels = $LABELS"
else
    echo "!!! data/labels.txt is required !!!!"
    echo "This file is a single line space seperated list of label names"
    exit 1
fi



# save_videolink_to_html(){
#     link=$1 
#     index=`echo $link | sed 's/.*id=\([0-9]\+\)&.*/\1/' `
#     echo "<a class='slice_link' href='$link'>slice_$index</a>" >> .html
# }



#  check videos directory
if [ ! -d "$TODOVIDEOPATH" ]
then
    echo "$TODOVIDEOPATH not exist"
    exit 1    
fi

chmod u+x ./scripts/tohtml.py

for VIDEONAME in $( ls $TODOVIDEOPATH ); do
    VIDEOID=`basename $VIDEONAME .mp4`
    if [ ! -d "$FRAMEPATH/$VIDEOID" ]
    then
        mkdir $FRAMEPATH/$VIDEOID
        # extract video to frames
        turkic extract $TODOVIDEOPATH/$VIDEONAME $FRAMEPATH/$VIDEOID --width 720 --height 480
        echo "extract $TODOVIDEOPATH/$VIDEONAME to $FRAMEPATH/$VIDEOID done" |tee -a $LOG_STARTUP
    fi

    mv $TODOVIDEOPATH/$VIDEONAME $DONEVIDEOPATH/$VIDEONAME

    # load frames and publish. This will print out access URLs.
    turkic load $VIDEOID $FRAMEPATH/$VIDEOID $LABELS $TURKOPS --blow-radius 0
    echo "load $VIDEOID done" |tee -a $LOG_STARTUP

    turkic publish --offline
    echo "publish $VIDEOID done" |tee -a $LOG_STARTUP

    # to html link
    turkic find --id $VIDEOID >${LINKPATH}/${VIDEOID}.txt
    ./scripts/tohtml.py ${LINKPATH}/${VIDEOID}.txt $HTMLPATH/${VIDEOID}.html
    echo "tohtml $VIDEOID done" |tee -a $LOG_STARTUP
done

# link to frames, otherwise link missing after docker containor restart
ls /root/vatic/data/frames_in/ |xargs -n 1 -i ln -sf /root/vatic/data/frames_in/{} /root/vatic/public/frames/{}

./scripts/fix_ip_port.sh

echo "done"
set +e