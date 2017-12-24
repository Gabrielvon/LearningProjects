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

########----------Crawling Part 1----------########
statpage = 2  #get from former part
# endpage = 229	#get from former part
endpage = 2
tol = 1
print time.asctime(), ":     Getting all links"

titles = []
links = []
flinks = open('nyt_links_v1.csv','ab+')
for i in range(statpage,endpage+tol):
	page = i+1
	url = "http://query.nytimes.com/search/sitesearch/?action=click&contentCollection&region=TopBar&WT.nav=searchWidget&module=SearchSubmit&pgtype=Homepage#/%s/from20141010to20151005/allresults/%d/allauthors/newest/" %(keywords,page)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	l_data = soup.find_all('div',{"class": "element2"})
	print l_data
	for item in l_data:
		print item.contents[3]
		# temp = item.contents[3]
		# pat = re.compile(r'http://(\S*)"')
		# link = re.search(pat,str(temp)).group()[:-1]
		# flinks.write(link+'\n')
		# links.append(link)
# print links
print time.asctime(), ":     All links retrived"
###################


# ########----------Crawling Part 2----------########
# ii = 0
# articles = {}
# fart = open('vergeart_v3.csv','ab+')
# writer = csv.writer(fart)
# writer.writerow(['Number','Datetime','Url','Text'])
# for link in links:
# 	try:
# 		source_code = requests.get(link)
# 		content = source_code.content
# 		soup = BeautifulSoup(content,"html.parser")
# 		g_data = soup.find_all('p')
# 		oneart = []
# 		for item in g_data:
# 			try:
# 				oneart.append(str(item.text.encode('utf8')))
# 			except Exception,e:
# 				continue
# 		try:
# 			datetime = re.search(r'\d+/\d+/\d+',link).group()
# 		except:
# 			datetime = 'Not Available'
# 		ii += 1
# 		data = ["%d" %ii, datetime, link, oneart]
# 		writer.writerow(data)
# 		print '\n\n\n',url
# 		print 'Retrived Articles %d' %ii

# 	except Exception, e:
# 		datetime = re.search(r'\d+/\d+/\d+',link).group()
# 		ii += 1
# 		data = ["%d" %ii, datetime, link, str(e)]
# 		writer.writerow(data)
# 		print e
# 		continue

# fart.close()
# print '\nGet', ii, 'articles\n'
# print time.asctime(), ':     All articles retrived and saved'
