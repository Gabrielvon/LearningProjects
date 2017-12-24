# -*- coding:utf-8 -*-

import urllib

url = "http://www.iplaypython.com/"

html = urllib.urlopen(url)

print html.read()

html.close

#下载网页
# urllib.urlretrieve(url,'iplaypython')

#geturl()
#getcode()