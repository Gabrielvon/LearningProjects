# http://investorplace.com
# We can easily find the time and title in the link.


# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import requests
from bs4 import BeautifulSoup
import re, time, traceback, csv

# keywords = 'apple'

def getsoup(url):
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")
	return soup

def invpla(keywords):
	########----------Find the page ranges----------########
	print time.asctime(), ":     Finding the page ranges"
	statpage = 0
	endpage = 0
	statdate = re.compile(r'\w*.*, 2014')
	enddate = re.compile(r'\w*.*, 2015')
	alter = re.compile(r'\w*.*, \d\d\d\d')

	for i in range(10000):
		try:
			page = i+1
			url = 'http://investorplace.com/search/?q=%s&qty=10&sort=date&start=%d&category=all' %(keywords,page)
			soup = getsoup(url)
		except Exception,e:
			print e
			time.sleep(60*20)			
			soup = getsoup(url)	

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
					yearpat = re.compile(r'\d\d\d\d')
					year = re.search(yearpat,datetext).group()
					# print type(year)
					if (int(year) < 2015):
						cdate1 = re.search(alter,datetext).group()
						statpage = page	
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
				cdate2 = re.search(alter,datetext).group()
				print cdate2
				continue

		try:
			current = re.search(r'20\w\w',datetext).group()
		except Exception,e:
			print 'Record time is before than 1999'
			print e
			current = 1999

		if (statpage >=1) & (endpage >=1):
			print "Ending Page Got"
			break
		else: 
			if(current <= 2013): 
				print 'Cannot find articles from 2014 to 2015'
				statpage = 1
				endpage = 2
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
	# flinks = open('investorplacelinks_v1.csv','ab+')
	for i in range(statpage-1,endpage+tol):
		try:
			page = i+1
			url = 'http://investorplace.com/search/?q=%s&qty=10&sort=date&start=%d&category=all' %(keywords,page)
			soup = getsoup(url)
		except Exception,e:
			print e
			time.sleep(60*20)
			soup = getsoup(url)

		l_data = soup.find_all('h3',{'class':'entry-title-others'})		
		for item in l_data:
			for ll in item.find_all('a'):
				link = ll.get('href')
				# flinks.write(link+'\n')
				links.append(link)

	print time.asctime(), ":     All links retrived"
	###################


	########----------Crawling Part 2----------########
	ii = 0
	fart = open('investorplaceart_all.csv','ab+')
	writer = csv.writer(fart)
	writer.writerow(['Number','keywords','Datetime','Title','Url','Text'])
	print '>>>>>-------Downloading Articles-------<<<<<'
	for link in links:
		try:
			soup = getsoup(link)
		except Exception,e:
			print e
			time.sleep(60*20)
			soup = getsoup(link)
				
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
			print keywords
			print title,'\n',datetime,'\n',link
			print 'Retrived Articles %d' %ii
			print '\n\n'	
		except Exception,e:
			print keywords
			print link			
			print 'Error occurs when writing into csv: ',str(e),'\n\n'
			alldata = ["%d" %ii, keywords, '', '', link, '']
			writer.writerow(alldata)
			continue

	fart.close()
	print '\nGet', ii, 'articles\n'
	print time.asctime(), ':     All articles retrived and saved'

# toget = ['AAPL', 'Apple Iphone', 'Ipad', 'Apple watch', 'macbook',' mac pro', 'Apple IOS', 'Apple OSX', 'Apple pay', 'Apple TV', 'retina', 'imac', 'Apple facetime', 'Apple siri', 'Apple Imessage', '3D touch', 'icloud', 'Apple', 'Ipod', 'Apple music', 'Apple support', 'Apple store', 'Apple service', 'Ibook', 'apple X service', 'apple Xsan', 'Timothy Donald Cook']
toget = ['apple','Apple Iphone', 'Ipad', 'Apple watch', 'macbook',' mac pro', 'Apple IOS', 'Apple OSX', 'Apple pay', 'Apple TV', 'retina', 'imac', 'Apple facetime', 'Apple siri', 'Apple Imessage', '3D touch', 'icloud', 'Apple', 'Ipod', 'Apple music', 'Apple support', 'Apple store', 'Apple service', 'Ibook', 'apple X service', 'apple Xsan', 'Timothy Donald Cook']
# toget = ['3D touch']
for word in toget:
	invpla(word)
