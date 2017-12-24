# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')
# sys.path.append('/usr/local/lib/python2.7/site-packages')

import nltk, csv, time, re, datetime, scipy
import pandas as pd
import numpy as np
from gensim.models import Word2Vec
from nltk.corpus import brown, movie_reviews, treebank
from time import strptime
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import SGDClassifier
from sklearn.naive_bayes import MultinomialNB

# def is_valid_date(str):
#   try:
#     time.strptime(str, "%Y-%m-%d")
#     return True
#   except:
#     return False

####---------- Load Data Frame ----------#####
# s3 = pd.read_json('prepdata_v2.json',orient='index').sort_index(ascending=False).head(50)
def findminw(textbydate):
	n = 0
	num = 10000000000
	for i in textbydate:
		n += 1
		inum = len(i)
		print type(i)
		print 'iter: ', n,'---',len(i), 'words'
		num = min(num,inum)
	print 'Minimum words within a day: ', num

# s3.to_json('itryprepdata_v2.json',orient='index')
s3 = pd.read_json('itryprepdata_v2.json',orient='index').sort_index(ascending=False).head(10)
s3text = s3['Textbydate']
print len(s3)
print type(s3)
#####---------- Tokenize ----------#####
# def str2words( mystr, remove_stopwords=False ):
#     # Function to convert a document to a sequence of words,
#     mystr.replace(r'\xc2\xa0', '').replace('\xe2\x80\x99', '\'').replace('\xe2\x80\x09', '\"')
#     words = re.sub("[^a-zA-Z]"," ", mystr).lower().split()
#     if remove_stopwords:
#         stops = set(stopwords.words("english"))
#         words = [w for w in words if not w in stops]
#     b=[]
#     stemmer = english_stemmer #PorterStemmer()
#     for word in words:
#         b.append(stemmer.stem(word))
#     return(words)

