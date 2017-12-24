# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import requests
from bs4 import BeautifulSoup
import re, traceback

# keywords = 'apple'

# def mysoupprettify(sourceurl):
# 	source_code = requests.get(sourceurl)
# 	content = source_code.content
# 	soup = BeautifulSoup(content,"html.parser")
# 	soup.prettify()

sourceurls = ('http://bgr.com/page/6/?s=apple',
	'http://www.wired.com/?s=APPLE&page=2&sort=score&order=desc',
	'http://www.macworld.com/search?query=apple&s=d&start=1500&t=2',
	'http://www.marketwatch.com/search?q=apple&m=Keyword&rpp=15&mp=806&bd=false&rs=false&o=46',
	'https://www.macnn.com/search/apple/?orderby=3&order=DESC&type=0&limit=25&start=50',
	'http://search.al.com/apple/1/all/?date_range=all',
	'http://search.cnbc.com/main.do?partnerId=2000&keywords=apple&sort=date&minimumrelevance=0.2&pubtime=0&pubfreq=a&categories=exclude&page=1000'
	)

testurls = ('http://bgr.com/2015/09/29/apple-music-usability-ios-9/',
	'http://www.wired.com/2015/09/recap-everything-new-apples-iphone-event/',
	'/article/2139384/expo-notes-why-audio-hijack-pro-is-the-podcasters-friend.html',
	'http://www.marketwatch.com/story/apple-up-06-leads-dow-gainers-in-early-friday-trade-2015-10-09',
	'//www.macnn.com/articles/15/10/15/macnns.os.x.app.update.for.oct.15.2015.130873/',
	'http://www.al.com/opinion/index.ssf/2015/02/apple_is_producing_a_car_but_c.html',
	'http://www.cnbc.com/id/101872895'
	)



# print mysoupprettify(sourceurls[4])


sourceurl = sourceurls[4]
source_code = requests.get(sourceurl)
# content = source_code.content
# soup = BeautifulSoup(content,"html.parser")
# soup.prettify()

