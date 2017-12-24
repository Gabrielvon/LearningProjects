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

def getsoup(url):
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")
	return soup

def wired(keywords):
	########----------Find the page ranges----------########
	print time.asctime(), ":  w    Finding the page ranges"
	statpage = 0
	endpage = 0
	statdate = re.compile(r'\w*.*, 2014')
	enddate = re.compile(r'\w*.*, 2015')
	for i in range(10000):
		try:
			page = i+1
			url = "http://www.wired.com/?s=%s&page=%d&sort=date&order=desc" %(keywords,page)
			soup = getsoup(url)
		except Exception,e:
			print e
			time.sleep(60*20)			
			soup = getsoup(url)	

		# Find pages
		g_data = soup.find_all('div',{'class':'search-results'})

		#Start page
		if statpage == 0:
			for item in g_data:
				for t in item.find_all('time'):
					datetext = str(t.text).strip()

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
			for t in item.find_all('time'):
				datetext = str(t.text).strip()


				try:
					cdate2 = re.search(statdate,datetext).group()
					print cdate2
					endpage = page
					print 'Ending page = ', page
					break
				except:
					cdate2 = ""
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
				endpage = 1
				break

	print time.asctime(), ":     Page ranges is from "+str(statpage)+" to "+str(endpage)		
	##################

	########----------Crawling Part 1----------########
	# statpage = 2  #get from former part
	# endpage = 59	#get from former part
	# endpage = 2
	print time.asctime(), ":     Getting all links"

	titles = []
	links = []
	flinks = open('wiredlinks_all.csv','ab+')
	for i in range(statpage,endpage):
		page = i+1
		url = "http://www.wired.com/?s=%s&page=%d&sort=date&order=desc" %(keywords,page)
		source_code = requests.get(url)
		content = source_code.content
		soup = BeautifulSoup(content,"html.parser")

		l_data = soup.find_all('div',{'class':'search-results'})

		for item in l_data:
			for ll in item.find_all('li'):
				for lll in ll.find_all('a'):
					link = lll.get('href')
					flinks.write(link+'\n')
					links.append(link)

	print time.asctime(), ":     All links retrived"
	###################


	########----------Crawling Part 2----------########
	ii = 0
	fart = open('wiredart_all.csv','ab+')
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

			g_data = soup.find_all('section',{'tabindex':'0'})
			oneart = []
			for item in g_data:
				try:
					oneart.append(str(item.text.encode('utf8')))
				except Exception,e:
					# print 'oneart',e
					oneart = ['Not Available',str(e)]
					continue

			tl_data = soup.find_all('h1',{'tabindex':'0'})
			try:
				for item in tl_data:
					title = item.text.encode('utf8').strip()
			except Exception,e:
				title = ['Not Available',str(e)]

			tm_data = soup.find_all('time')
			date = []
			for item in tm_data:
				datetext = str(item.text.strip())
				date.append(datetext)
			pat = re.compile(r'\d\d.\d\d.\d\d')
			try:
				datetime = re.search(pat,str(date)).group()
			except Exception,e:
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

toget = ['AAPL', 'Apple Iphone', 'Ipad', 'Apple watch', 'macbook',' mac pro', 'Apple IOS', 'Apple OSX', 'Apple pay', 'Apple TV', 'retina', 'imac', 'Apple facetime', 'Apple siri', 'Apple Imessage', '3D touch', 'icloud', 'Apple', 'Ipod', 'Apple music', 'Apple support', 'Apple store', 'Apple service', 'Ibook', 'apple X service', 'apple Xsan', 'Timothy Donald Cook']
# toget = ['apple','Apple Iphone', 'Ipad', 'Apple watch', 'macbook',' mac pro', 'Apple IOS', 'Apple OSX', 'Apple pay', 'Apple TV', 'retina', 'imac', 'Apple facetime', 'Apple siri', 'Apple Imessage', '3D touch', 'icloud', 'Apple', 'Ipod', 'Apple music', 'Apple support', 'Apple store', 'Apple service', 'Ibook', 'apple X service', 'apple Xsan', 'Timothy Donald Cook']
for word in toget:
	wired(word)

