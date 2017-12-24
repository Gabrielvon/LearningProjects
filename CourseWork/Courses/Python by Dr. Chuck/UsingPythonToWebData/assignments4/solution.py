# $ python solution.py 
# Enter location: http://pr4e.dr-chuck.com/tsugi/mod/python-data/data/comments_42.xml
# Retrieving http://pr4e.dr-chuck.com/tsugi/mod/python-data/data/comments_42.xml
# Retrieved 4210 characters
# Count: 50
# Sum: 2553

url = raw_input('Enter URL: ')
print 'Retrieving: ', url
# url = 'http://pr4e.dr-chuck.com/tsugi/mod/python-data/data/comments_42.xml '
# url = ' http://pr4e.dr-chuck.com/tsugi/mod/python-data/data/comments_185732.xml'

# Retrieve all of the anchor tags
import urllib
import xml.etree.ElementTree as ET
html = urllib.urlopen(url).read()
tree = ET.fromstring(html)
# for i in tree:
# 	for i1 in i:
# 		for i2 in i1:
# 			print i2.text

# Counting and Sum
allcounts =  tree.findall('.//count')
count = len(allcounts)
print 'Count: ', count
mysum = 0
for item in allcounts:
	sum += int(item.text)
print 'Sum: ', mysum
