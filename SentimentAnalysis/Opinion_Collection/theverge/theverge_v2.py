# theverge_v2.py
# We can easily find the time and title in the link.


# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import requests
from bs4 import BeautifulSoup
import re
import time 
import traceback
import csv

keywords = 'apple'


########----------Find the page ranges----------########
print time.asctime(), ":     Finding the page ranges"
statpage = 0
endpage = 0
statdate = 'October 8, 2014'
enddate = 'October 8, 2015'
for i in range(10000):
	page = i+1
	url = "http://www.theverge.com/search?order=date&page=%d&q=%s" %(page,keywords)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	# Find pages
	g_data = soup.find_all('p',{"class": "byline"})

	#Start page
	if statpage == 0:
		for item in g_data:
			datetext = item.contents[2]

			try:
				cdate1 = re.search(enddate,datetext).group()
				print cdate1
				statpage = page
				print 'Starting page = ', page
				break
			except:
				cdate1 = ""
				continue
		if statpage > 0:
			print "Starting Page Got"
	
	#Ending page
	for item in g_data:
		datetext = item.contents[2]

		try:
			cdate2 = re.search(statdate,datetext).group()
			print cdate2
			endpage = page
			print 'Ending page = ', page
			break
		except:
			cdate2 = ""
			continue
	
	if len(cdate1) >=1 & len(cdate2) >=1:
		print "Ending Page Got"
		break

print time.asctime(), ":     Page ranges is from "+str(statpage)+" to "+str(endpage)		
##################

########----------Crawling Part 1----------########
# statpage = 2  #get from former part
# endpage = 229	#get from former part
# endpage = 2
tol = 5
print time.asctime(), ":     Getting all links"

titles = []
links = []
flinks = open('vergelinks_v2.csv','ab+')
for i in range(statpage,endpage+tol):
	page = i+1
	url = "http://www.theverge.com/search?order=date&page=%d&q=%s" %(page,keywords)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	l_data = soup.find_all('div',{"class": "body"})
	for item in l_data:
		temp = item.contents[3]
		pat = re.compile(r'http://(\S*)"')
		link = re.search(pat,str(temp)).group()[:-1]
		flinks.write(link+'\n')
		links.append(link)

print time.asctime(), ":     All links retrived"
###################


# ########----------Crawling Part 2----------########
ii = 0
articles = {}
fart = open('vergeart_v2.csv','ab+')
writer = csv.writer(fart)
writer.writerow(['Number','Datetime','Url','Text'])
for link in links:
	try:
		source_code = requests.get(link)
		content = source_code.content
		soup = BeautifulSoup(content,"html.parser")
		g_data = soup.find_all('div',{"class": "m-article__entry"})
		oneart = []
		for item in g_data:
			temps = item.contents
			for temp in temps:
				try:
					oneart.append(str(temp.text.encode('utf8')))
				except Exception,e:
					continue
		try:
			datetime = re.search(r'\d+/\d+/\d+',link).group()
		except:
			datetime = 'Not Available'
		ii += 1
		data = ["%d" %ii, datetime, link, oneart]
		writer.writerow(data)
		print '\n\n\n',url
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
