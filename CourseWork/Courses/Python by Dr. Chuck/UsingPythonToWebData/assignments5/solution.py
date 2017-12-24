
# $ python solution.py 

# url = raw_input('Enter URL: ')
# url = 'http://python-data.dr-chuck.net/comments_42.json'
url = 'http://python-data.dr-chuck.net/comments_185736.json'
print 'Enter location: ', url
print 'Retrieving: ', url

# Retrieve all of the anchor tags
import urllib, json
html = urllib.urlopen(url).read()
print 'Retrieved ', len(html), ' characters'
info = json.loads(html)
mysum=0
count=0
for item in info['comments']:
	mysum += item['count']
	count += 1

print 'Count: ', count
print 'Sum: ', mysum
