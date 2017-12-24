# bloombergnews_v3.py
# We can easily find the time and title in the link.


# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import requests
from bs4 import BeautifulSoup
import re, time, traceback, csv


keywords = 'apple'


########----------Find the page ranges----------########
print time.asctime(), ":     Finding the page ranges"
statpage = 0
endpage = 0
statdate = '2015-10-09' # there are no news on 10/10/2015
enddate = '2014-10-05'

for i in range(10000):
	page = i+1
	url = "http://www.bloomberg.com/search?query=%s&sort=time:desc&page=%d" %(keywords,page)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	# Find pages
	g_data = soup.find_all('div',{"class": "search-result"})
	# g_data = soup.find_all('article',{"class": "search-result-story site-bbiz type-article"})

	print i
	if statpage == 0:
		for item in g_data:
			i2time = item.find_all('span',{"class": "metadata-timestamp"})
			timepat = r'datetime=".*"'
			posttime = re.search(timepat,str(i2time)).group()[10:-1]

			i2link = item.find_all('h1')
			linkpat = r'href=".*"'
			extlink = re.search(linkpat,str(i2link)).group()[6:-1]
			if statdate in extlink:
				print "Starting Page Got: Page"+str(i)
				statpage = i
				print '\n'
				break
	
	#Ending page
	for item in g_data:
		i2time = item.find_all('span',{"class": "metadata-timestamp"})
		timepat = r'datetime=".*"'
		posttime = re.search(timepat,str(i2time)).group()[10:-1]

		i2link = item.find_all('h1')
		linkpat = r'href=".*"'
		extlink = re.search(linkpat,str(i2link)).group()[6:-1]
		if enddate in extlink:
			print "Ending Page Got: Page"+str(i)
			endpage = i
			print '\n'
			break
	
	if endpage-statpage >= 1:
		print "Ending Page Got"
		break

print time.asctime(), ":     Page ranges is from "+str(statpage)+" to "+str(endpage)		
##################

########----------Crawling Part 1----------########
# statpage = 3  #get from former part
# endpage = 343	#get from former part
# endpage = 3
tol = 2
print time.asctime(), ":     Getting all links"

links = []
flinks = open('blmbglinks_v2.csv','ab+')
for i in range(statpage,endpage+tol):
	page = i+1
	url = "http://www.bloomberg.com/search?query=%s&sort=time:desc&page=%d" %(keywords,page)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	g_data = soup.find_all('div',{"class": "search-result"})
	# g_data = soup.find_all('article',{"class": "search-result-story site-bbiz type-article"})
	for item in g_data:
		i2time = item.find_all('span',{"class": "metadata-timestamp"})
		timepat = r'datetime=".*"'
		posttime = re.search(timepat,str(i2time)).group()[10:-1]

		i2link = item.find_all('h1')
		linkpat = r'href=".*"'
		extlink = re.search(linkpat,str(i2link)).group()[6:-1]
		# print extlink
		# if keywords in extlink:
		domain = 'http://www.bloomberg.com'
		link = domain+'/'+extlink
		flinks.write(link+'\n')
		links.append(link)

print time.asctime(), ":     All links retrived"
###################
flinks.close()

########----------Crawling Part 2----------########
ii = 0
articles = {}
fart = open('blmbgart_v2.csv','ab+')
writer = csv.writer(fart)
writer.writerow(['Number','Datetime','Url','Text'])
for link in links:
	try:
		source_code = requests.get(link)
		content = source_code.content
		soup = BeautifulSoup(content,"html.parser")
		g_data = soup.find_all('div',{"class":"article-body__content"})
		oneart = []
		for item in g_data:
			try:
				oneart.append(str(item.text.decode('utf8')))
			except Exception,e:
				continue
		try:
			datetime = re.search(r'\d+-\d+-\d+',link).group()
		except:
			datetime = 'Not Available'
		ii += 1
		data = ["%d" %ii, datetime, link, oneart]
		writer.writerow(data)
		print '\n\n\n',link
		print 'Retrived Articles %d' %ii

	except Exception, e:
		datetime = re.search(r'\d+/\d+/\d+',link).group()
		ii += 1
		data = ["%d" %ii, datetime, link, str(e)]
		writer.writerow(data)
		print e
		continue

fart.close()
print '\nGet', ii, 'articles\n'
print time.asctime(), ':     All articles retrived and saved'
