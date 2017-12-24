

# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import requests
from bs4 import BeautifulSoup
import re
import time 
import traceback

keywords = 'apple'

########----------Find the page ranges----------########
# statpage = 0
# endpage = 0
# for i in range(10000):
# 	page = i+1
# 	url = "http://www.theverge.com/search?order=date&page=%d&q=%s" %(page,keywords)
# 	source_code = requests.get(url)
# 	content = source_code.content
# 	soup = BeautifulSoup(content,"html.parser")

# 	# Find pages
# 	g_data = soup.find_all('p',{"class": "byline"})

# 	#Start page
# 	enddate = 'October 8, 2015'
# 	if statpage == 0:
# 		for item in g_data:
# 			datetext = item.contents[2]

# 			try:
# 				cdate1 = re.search(enddate,datetext).group()
# 				print cdate1
# 				statpage = page
# 				print 'Starting page = ', page
# 				break
# 			except:
# 				cdate1 = ""
# 				continue
# 		if statpage > 0:
# 			print ">>>----------Starting Page Got----------<<<<"
# 	#Ending page
# 	statdate = 'October 8, 2014'
# 	for item in g_data:
# 		datetext = item.contents[2]

# 		try:
# 			cdate2 = re.search(statdate,datetext).group()
# 			print cdate2
# 			endpage = page
# 			print 'Ending page = ', page
# 			break
# 		except:
# 			cdate2 = ""
# 			continue
	
# 	if len(cdate1) >=1 & len(cdate2) >=1:
# 		print ">>>----------Ending Page Got----------<<<<"
# 		break
###################

########----------Crawling Part 1----------########
statpage = 2  #get from former part
# endpage = 229	#get from former part
endpage = 3
tol = 0
print time.asctime(), ":     Getting all links"

titles = []
links = []
for i in range(statpage,endpage+tol):
	i = 1
	page = i+1
	url = "http://www.theverge.com/search?order=date&page=%d&q=%s" %(page,keywords)
	source_code = requests.get(url)
	content = source_code.content
	soup = BeautifulSoup(content,"html.parser")

	g_data = soup.find_all('div',{"class": "body"})
	for item in g_data:
		title = item.contents[3].text
		titles.append(str(title))

	l_data = soup.find_all('div',{"class": "body"})
	for item in l_data:
		temp = item.contents[3]
		pat = re.compile(r'http://(\S*)"')
		link = re.search(pat,str(temp)).group()[:-1]
		links.append(link)

print time.asctime(), ":     All links retrived"
###################


########----------Crawling Part 2----------########
ii = 0
articles = {}
for url in links:
	try:
		source_code = requests.get(url)
		content = source_code.content
		soup = BeautifulSoup(content,"html.parser")
		g_data = soup.find_all('div',{"class": "m-article__entry"})
		oneart = []
		for item in g_data:
			temps = item.contents
			for temp in temps:
				try:
					oneart.append(str(temp.text))
				except Exception,e:
					continue

		articles['Articles %d' %ii] = [str(url),oneart]
		ii += 1
		print '\n\n\n',url
		print 'Retrived Articles %d' %ii

	except Exception, e:
		print e
		continue
		break

# print articles
saveFile = open('theverge_v1.csv','ab')
for text in articles:
	print text
	saveFile.write('Articles %d' %ii)
	saveFile.write('\n')
	saveFile.write(text)
	saveFile.write('\n\n\n')

# # print oneart
# # saveFile.write('Link: '+url+'\n')
# # saveFile.write('Articles %d' %ii + '\n' + oneart)
# # saveFile.write('\n\n\n')



# saveFile.close()
# print '\nGet', len(articles), 'articles\n'
# print time.asctime(), ':     All articles retrived and saved'