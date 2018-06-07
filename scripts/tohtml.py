#!/usr/bin/python

import os,sys
import re

linkfile=sys.argv[1]
htmlfile=sys.argv[2]
(videoid,extension) = os.path.splitext(os.path.basename(linkfile));

html_strs='<span>{}</span>:'.format(videoid)

with open(linkfile) as f:
	i=0
	for x in f.readlines():
		# http://localhost/?id=1&hitId=offline
		i+=1
		id=re.match("http.*\?id=(\d+)&.*",x).groups()[0]
		html_strs+='<a class="slice_link" href="{}">slice_{}</a> | '.format(x,i)

with open(htmlfile,'w') as f:
	f.write(html_strs)