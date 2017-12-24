#Import the necessary methods from tweepy library
# from twython import Twython

# #Variables that contains the user credentials to access Twitter API 
# access_token = "" #ENTER YOUR ACCESS TOKEN
# access_token_secret = "" #ENTER YOUR ACCESS TOKEN SECRET
# consumer_key = ""
# consumer_secret = ""

# t = Twython(app_key=consumer_key, app_secret=consumer_secret, oauth_token=access_token,oauth_token_secret=access_token_secret)

# search = t.search(q='$tsla', count=100)
# tweets = search['statuses']


# for tweet in tweets:
# 	try:
# 		print tweet['id_str'], '\n', tweet['text'], '\n\n\n'
# 	except BaseException,e:
# 		print 'failllllllllllllllllll', '\n\n\n'



## Next example for FB

# Import the necessary methods from tweepy library
from twython import Twython

#Variables that contains the user credentials to access Twitter API 
access_token = "" #ENTER YOUR ACCESS TOKEN
access_token_secret = "" #ENTER YOUR ACCESS TOKEN SECRET
consumer_key = ""
consumer_secret = ""

t = Twython(app_key=consumer_key, app_secret=consumer_secret, oauth_token=access_token,oauth_token_secret=access_token_secret)

search = t.search(q='$FB', count=100)
tweets = search['statuses']

# for tweet in tweets:
# 	print tweets

for tweet in tweets:
	try:
		print tweet['id_str'], '\n', tweet['text'], '\n\n\n'
	except BaseException,e:
		print 'failllllllllllllllllll', '\n\n\n'
