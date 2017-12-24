# theverge_v3.py
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
statdate = 'October 1, 2014'
enddate = 'October 12, 2015'
for i in range(10000):
	page = i+1
	url = "http://www.bgr.com/page/%d/?s=%s" %(page,keywords)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	# Find pages
	g_data = soup.find_all('span',{"class": "entry-date"})

	#Start page
	if statpage == 0:
		for item in g_data:
			datetext = item.text

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
		datetext = item.text

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
# endpage = 114	#get from former part
# endpage = 2
tol = 5
print time.asctime(), ":     Getting all links"

titles = []
links = []
flinks = open('bgrlinks_v1.csv','ab+')
for i in range(statpage-1,endpage+tol):
	page = i+1
	url = "http://www.bgr.com/page/%d/?s=%s" %(page,keywords)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	l_data = soup.find_all('header',{"class": "entry-header"})
	for item in l_data:
		rlinks = item.find_all('a')
		pat = re.compile(r'http://(\S*)"')	
		link = re.search(pat,str(rlinks)).group()[:-1]
		flinks.write(link+'\n')
		links.append(link)

print time.asctime(), ":     All links retrived"
###################


########----------Crawling Part 2----------########
ii = 0
fart = open('bgrart_v1.csv','ab+')
writer = csv.writer(fart)
writer.writerow(['Number','Datetime','Title','Url','Text'])
print '>>>>>-------Downloading Articles-------<<<<<'
for link in links:
	try:
		source_code = requests.get(link)
		content = source_code.content
		soup = BeautifulSoup(content,"html.parser")
		
		g_data = soup.find_all('div',{'id':'content','role':'main'})
		oneart = []
		for item in g_data:
			for cont in item.find_all('p'):
				try:
					oneart.append(str(cont.text.encode('utf8')))
				except Exception,e:
					# print 'oneart',e
					oneart = ['Not Available',str(e)]
					continue

		t_data = soup.find_all('h1',{'class':'entry-title'})
		try:
			for item in t_data:
				title = item.text.encode('utf8').strip()
		except Exception,e:
			# print 'title',e
			title = ['Not Available',str(e)]

		try:
			datetime = re.search(r'\d+/\d+/\d+',link).group()
		except Exception,e:
			# print 'datetime',e
			datetime = ['Not Available',str(e)]


		ii += 1
		data = ["%d" %ii, datetime, title, link, oneart]
		writer.writerow(data)
		print title
		print datetime
		print link
		print 'Retrived Articles %d' %ii
		print '\n\n'

	except Exception, e:
		datetime = re.search(r'\d+/\d+/\d+',link).group()
		ii += 1
		data = ["%d" %ii, datetime, title, link, oneart]
		writer.writerow(data)
		print e
		continue

fart.close()
print '\nGet', ii, 'articles\n'
print time.asctime(), ':     All articles retrived and saved'
