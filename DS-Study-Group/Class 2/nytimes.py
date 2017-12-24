### iTry Cookies ###

# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

#### Download source code text
import urllib
import urllib2
url = "http://www.wsj.com"

# # Method 1: Basic (submit request and get response)
# req = urllib2.Request(url)
# response = urllib2.urlopen(req)
# # print type(response) #<type 'instance'>
# # print type(response.read()) #str

# # Method 2: Cookielib
# import cookielib
# #Create a CookieJar object to save cookie
# cookie = cookielib.CookieJar()
# #Use HTTPCookieProcessor object of urllib2 package to create cookie processor
# handler=urllib2.HTTPCookieProcessor(cookie)
# #build opener through handler
# opener = urllib2.build_opener(handler)
# # cookie.save(ignore_discard=True, ignore_expires=True)
# #Here, opener.open is similar to urlopen. You can also pass request to it.
# response = opener.open(url)
# # print type(response) #<type 'instance'>
# # print type(response.read()) #str

# Method 3: nicer pacakage (the way is same as method 1)
import requests
source_code = requests.get(url)
content = source_code.content
# print content
# print type(source_code) #<class 'requests.models.Response'>
# print type(source_code.content) # str




#### Analyse source code
# Method 1: Using re
# import re
# pattern = r'<a class="subPrev headline" href="\S+" data-referer="\S+"> [\w+\s]+ </a>'
# urlall ='<a class="subPrev headline" href="http://www.wsj.com/articles/eu-move-to-force-relocation-of-migrants-deepens-divisions-in-europe-1442964124" data-referer="/news/world"> Clash Over Migrants Widens EU Rift </a>'
# test = re.findall(pattern,urlall)
# print test
# pat1 = r'<a href=\S+'
# strings1 = re.findall(pat1,content)
# for i in strings1:
# 	print i

##!!Practices!!
# #'">Fracking Firms That Drove Oil Boom Struggle to Survive</a></h3>'
# pat2 = r'">[\w+\s]+</a></h3>'
# strings2 = re.findall(pat2,content)
# # print strings2
# for i in strings2:
# 	print i

# strings3 = []
# pat3 = r'[\w+\s]+[a-zA-Z]'
# for i in strings2:
# 	strings3.append(re.findall(pat3,i))
# # print strings3
# for i in strings3:
# 	print i


# Method 2: Using bs
from bs4 import BeautifulSoup

soup = BeautifulSoup(content,"html.parser")

#One common task is extracting all the URLs
# for link in soup.find_all('a'):
# 	print link.get('href')
#Another common task is extracting all the text from a page:
print soup.get_text()

#Advanced ways
g_data = soup.find_all('div',{"class": " space-bottom column"})
print len(g_data)
# for item in g_data:
	# print item.contents[0].text
	# print item.contents[1].text