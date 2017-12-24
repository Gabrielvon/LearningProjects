# Gabriel Trys on WSJ.COM
# Nasdaq + all children pages

#import urllib
#import requests
import urllib2
from bs4 import BeautifulSoup

url = 'http://www.wsj.com'
request = urllib2.Request(url)
html = urllib2.urlopen(request).read()

#r = requests.get(url)
#soup = BeautifulSoup(r.content)
soup = BeautifulSoup(html)
links = soup.findAll("a")

words = []

for link in links:
	#print "<a href='%s'>%s</a>" %(link.get("href"),link.text)
	words.append(link.text)
# 	print link.text

# print type(words)
# print len(words)

count = 0
loc_China = []
for ww in words:
	#loc = ww.find('China' or 'china')
	loc = ww.find('China')
	count += 1 # count = count + 1
 	if loc == -1:
		loc = 'None'
	else:
		loc_China.append(count)
	# print str(count) + ' ' + str(loc) + ' ' + ww

print '\n\n\n\n\n\n'
for num in loc_China:
	print str(num) + ' ' + words[num] + ' ' + links[num].get('href')



