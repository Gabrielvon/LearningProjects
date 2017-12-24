# Note - this code must run in Python 2.x and you must download
# http://www.pythonlearn.com/code/BeautifulSoup.py
# Into the same folder as this program

import urllib
from BeautifulSoup import *

url = raw_input('Enter URL: ')
count = raw_input('Enter: ')
position = raw_input('Enter: ')
# url = 'http://pr4e.dr-chuck.com/tsugi/mod/python-data/data/known_by_Iria.html'
# url = 'http://pr4e.dr-chuck.com/tsugi/mod/python-data/data/known_by_Lukmaan.html'
# count = 7
# position = 18


# Retrieve all of the anchor tags
def iloop(url, icount):
	html = urllib.urlopen(url).read()
	soup = BeautifulSoup(html)
	tags = soup('a')
	n = 0
	for tag in tags:
		n += 1
		if n == icount:
			link = tag.get('href')
			return link
			break

for i in range(count+1):
	if i == position+1:
		print 'Last Url: ', url
	else:
		print 'Retrieving: ', url	
	url = iloop(url,position)

