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
statdate = re.compile(r'Oct\w*.* 1, 2014')
enddate = re.compile(r'Oct\w*.* 13, 2015')
for i in range(10000):
	page = i+1
	url = 'http://investorplace.com/search/?q=%s&qty=10&sort=date&start=%d&category=all' %(keywords,page)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	# Find pages
	g_data = soup.findAll('p',{'class':'search-meta'})

	#Start page
	if statpage == 0:
		for item in g_data:
			datetext = str(item.text)

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
		datetext = str(item.text)

		try:
			cdate2 = re.search(statdate,datetext).group()
			print cdate2
			endpage = page
			print 'Ending page = ', page
			break
		except:
			cdate2 = ""
			continue
	
	if (statpage >=1) & (endpage >=1):
		print "Ending Page Got"
		break

print time.asctime(), ":     Page ranges is from "+str(statpage)+" to "+str(endpage)		
##################

########----------Crawling Part 1----------########
# statpage = 2  #get from former part
# endpage = 47	#get from former part
# endpage = 2
tol = 5
print time.asctime(), ":     Getting all links"

links = []
flinks = open('investorplacelinks_v1.csv','ab+')
for i in range(statpage-1,endpage+tol):
	page = i+1
	url = 'http://investorplace.com/search/?q=%s&qty=10&sort=date&start=%d&category=all' %(keywords,page)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	l_data = soup.find_all('h3',{'class':'entry-title-others'})
	
	for item in l_data:
		for ll in item.find_all('a'):
			link = ll.get('href')
			flinks.write(link+'\n')
			links.append(link)

print time.asctime(), ":     All links retrived"
###################


########----------Crawling Part 2----------########
ii = 0
fart = open('investorplaceart_v1.csv','ab+')
writer = csv.writer(fart)
writer.writerow(['Number','keywords','Datetime','Title','Url','Text'])
print '>>>>>-------Downloading Articles-------<<<<<'
for link in links:
	source_code = requests.get(link)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")
	g_data = soup.find_all('div',{'class':'entry-content'})
	oneart = []
	for item in g_data:
		for art in item.findAll('p'):
			try:
				oneart.append(str(art.text.encode('utf8')))
			except Exception,e:
				# print 'oneart',e
				oneart = ['Not Available',str(e)]
				# continue

	t_data = soup.find_all('h1',{'class':'entry-title'})
	for item in t_data:
		try:
			title = item.text.encode('utf8').strip()
		except Exception,e:
			# print 'title',e
			title = ['Not Available',str(e)]

	data = soup.find_all('span',{'class':'entry-date'})
	for item in data:
		try:
			datetime = item.text.strip()
		except Exception,e:
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
