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
	
	if statpage >=1 & endpage >=1:
		print "Ending Page Got"
		break

print time.asctime(), ":     Page ranges is from "+str(statpage)+" to "+str(endpage)		
##################

########----------Crawling Part 1----------########
# statpage = 10  #get from former part
# endpage = 229	#get from former part
# endpage = 20
tol = 5
print time.asctime(), ":     Getting all links"

links = []
flinks = open('vergelinks_v4.csv','ab+')
for i in range(statpage,endpage+tol):
	page = i+1
	url = "http://www.theverge.com/search?order=date&page=%d&q=%s" %(page,keywords)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	l_data = soup.find_all('div',{"class": "body"})
	for item in l_data:
		for ll in item.findAll('a'):
			link = ll.get('href')
			if re.search(r'\d+/\d+/\d+',link):
				flinks.write(link+'\n')
				links.append(link)

print time.asctime(), ":     All links retrived"
###################
flinks.close()

########----------Crawling Part 2----------########
ii = 0
articles = {}
fart = open('vergeart_v5.csv','ab+')
writer = csv.writer(fart)
writer.writerow(['Number','Datetime','Url','Text'])
for link in links:
	source_code = requests.get(link)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")
	g_data = soup.find_all('p')
	oneart = []
	for item in g_data:
		try:
			oneart.append(str(item.text.encode('utf8')))
		except Exception,e:
			continue

	tl_data = soup.find_all('h1',{'class':'instapaper_title','id':'stream_title'})
	for item in tl_data:
		try:
			title = item.text.encode('utf8').strip()
		except Exception,e:
			# print 'title',e
			title = ['Title Is Not Available',str(e)]
			
	try:
		datetime = re.search(r'\d+/\d+/\d+',link).group()
	except:
		# print 'datetime',e
		datetime = ['Not Available',str(e)]
			
	ii += 1		
	try:
		alldata = ["%d" %ii, keywords, datetime, title, link, oneart]
		writer.writerow(alldata)
		print title,'\n',datetime,'\n',link
		print 'Retrived Articles %d' %ii
		print '\n\n'	
	except Exception,e:
		print 'Error occurs when writing into csv: ',str(e),'\n\n'
		alldata = ["%d" %ii, keywords, '', '', link, '']
		writer.writerow(alldata)
		continue

fart.close()
print '\nGet', ii, 'articles\n'
print time.asctime(), ':     All articles retrived and saved'
