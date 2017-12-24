# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import nltk, csv, time, re, datetime
from gensim.models import Word2Vec
from nltk.corpus import brown, movie_reviews, treebank
from time import strptime
import pandas as pd
import numpy as np

fields = ['Number','keywords','Datetime','Title','Url','Text']
bgr = pd.read_table('bgr_all.csv',sep=",")
blmbg = pd.read_table('blmbgart_all.csv',sep=",")
invpla = pd.read_table('invplaart_all.csv',sep=",")
wired = pd.read_table('wiredart_all.csv',sep=",")
cnbc = pd.read_table('cnbc_all.csv',sep=",",na_values=False,warn_bad_lines=True,parse_dates=True)
mktw = pd.read_table('mktwart_all.csv',sep=",",usecols=fields,error_bad_lines=False,na_values=False,parse_dates=True)
# theverge = pd.read_table('thevergeart_all.csv',sep=",")
# binsider = pd.read_table('binsider_allv2.csv',sep=",")
# csvs = ['bgr','blmbg','invpla','theverge','wired','cnbc','mktw']
csvs = ['bgr','blmbg','invpla','wired','cnbc','mktw']
# csvs = ['bgr']


s = pd.DataFrame([])
for csv in csvs:
	temp = eval(csv)
	rows = len(temp)
	print csv, rows, 'articles'
	label = np.array(csv)
	labelcol = np.tile(label,rows)
	temp['s'] = pd.Series(labelcol)
	s = s.append(temp, ignore_index=True)

s = s.drop(['Number'],axis=1)
colnames = ['Keywords','Dates','Headlines','Links','Articles','Sources']
s.columns = colnames
# print list(s), len(s)

#####---------- Adjust the date format ----------#####
def is_valid_date(str):
  try:
    time.strptime(str, "%Y-%m-%d")
    return True
  except:
    return False
def fixtime(year,month,day):
	dateC=datetime.datetime(year,month,day)
	timestamp=time.mktime(dateC.timetuple())
	ltime=time.localtime(timestamp)
	timeStr=time.strftime("%Y-%m-%d", ltime)
	return timeStr
def dofixtime(dates):
	pat1 = re.compile(r'\d{4}/\d*/\d*$')
	pat2 = re.compile(r'\d\d\.\d\d\.\d\d')
	pat3 = re.compile(r'\w+.*, \d{4}') #Oct 18, 2001 5:14 p.m. ET 
	pat4 = re.compile(r'\d\d Hours.*') #11 Hours Ago 
	pat5 = re.compile(r'\d* \w+ \d{4}')#Thursday, 22 Oct 2015 |  7:19  PM ET  
	myfixdates = []
	odates = []
	date = '00000000'
	for i in dates:
		tt = str(i)
		t1 = re.search(pat1,tt)	
		t2 = re.search(pat2,tt)
		t3 = re.search(pat3,tt)
		t4 = re.search(pat4,tt)
		t5 = re.search(pat5,tt)
		if t1: 
			date1 = t1.group().split('/')
			date = fixtime(int(date1[0]),int(date1[1]),int(date1[2]))				
			myfixdates.append(date)
			odates.append(i)	
		else:
			if t2:
				date2 = t2.group().split('.')
				date = fixtime(int(date2[2]),int(date2[0]),int(date2[1]))
				myfixdates.append(date)
				odates.append(i)
			else: 
				if t3:
					date3 = t3.group().split()
					mon = strptime(date3[0][0:3],'%b').tm_mon
					date = fixtime(int(date3[2]),mon,int(date3[1][:-1]))
					myfixdates.append(date)
					odates.append(i)
				else:
					if t4:
						myfixdates.append(date)
						odates.append(i)
					else:
						if t5:
							date5 = t5.group().split()
							mon = strptime(date5[1][0:3],'%b').tm_mon
							date = fixtime(int(date5[2]),mon,int(date5[0]))
							myfixdates.append(date)
							odates.append(i)
						else:
							if is_valid_date(i):
								myfixdates.append(i)
								odates.append(i)	
							else:
								myfixdates.append([date])
								odates.append(i)	

		if (date in dir()): del date				
	return myfixdates,odates

dates = set(s['Dates'])
fixeddates = dofixtime(dates)
# print type(dates), len(dates)
# print type(fixeddates), len(fixeddates)
fix = pd.Series(fixeddates[0],index=fixeddates[1],name='Fixeddates')
fixdf = pd.DataFrame(fix)
s = pd.merge(s,fixdf,left_on='Dates',right_index=True,how='outer')
s = s[(s['Fixeddates']>='2014-10-08')&(s['Fixeddates']<='2015-10-08')].sort(ascending=False)
s = s[(s['Keywords']!='keywords') & (s['Articles']!='[]')] # delete the row with only column names
s = s.drop_duplicates(subset=['Dates','Headlines','Links'])
s = s.drop_duplicates(subset=['Articles'])

prepda = s[['Fixeddates','Articles']].sort(columns='Fixeddates',ascending=False).reset_index(drop=True)
prepda.to_csv('prepdata_v1.csv', encoding='utf-8', index=False)


# #####---------- Tokenize ----------#####
# def str2words(mystr):
# 	mystr.replace('\xc2\xa0', '').replace(r'\xe2\x80\x99', '\'').replace(r'\xe2\x80\x9', '\"')
# 	words = nltk.word_tokenize(mystr)
# 	return words

# words = []
# print len(prepdata)
# for i in range(len(prepdata)):
# 	print i
# 	ww = str2words(prepdata['Articles'][i])
# 	tt = prepdata['Dates'][i]
# 	words.append([tt,ww])

# # print len(words)
# print len(prepdata)


