import urlparse
import urllib
import requests
from bs4 import BeautifulSoup


url = "http://www.yellowpages.com/search?search_terms=coffee&geo_location_terms=Los+Angeles%2C+CA"
url_page_2 = url + "&page=" + str(2)

# def get_data_from_url(url,10)

r = requests.get(url)

soup = BeautifulSoup(r.content)

links = soup.find_all("a")
print links

for link in links:
	print "<a href='%s'>%s</a>" %(link.get("href"),link.text)

#for link in soup.find_all('a'):
#	print link.get('href')

#for link in soup.find_all("a"):
#	print link.text

#for link in soup.find_all("a"):
#	print link.text, link.get('href')

#for link in soup.find_all("a"):
#	print "<a href='%s'>%s</a>" %(link.get("href"),link.text)

g_data = soup.find_all("div",{"class": "info"})
for item in g_data:
	print item.text

for item in g_data:
	print item.contents[0].text
	print item.contents[1].text

for item in g_data:
	print item.contents[0].find_all("a",{"class": "business-name"})[0].text
	#print item.contents[1].find_all("p",{"class": "adr"})[0].text
	try:
		#print item.contents[1].find_all("span",{"itemprop": "address"})[0].text
		print item.contents[1].find_all("span",{"itemprop": "streetAddress"})[0].text
	except:
		pass
	try:
		#print item.contents[1].find_all("span",{"itemprop": "address"})[0].text
		print item.contents[1].find_all("span",{"itemprop": "addressLocality"})[0].text.replace(',', '')
	except:
		pass
	try:
		#print item.contents[1].find_all("span",{"itemprop": "address"})[0].text
		print item.contents[1].find_all("span",{"itemprop": "addressRegion"})[0].text
	except:
		pass
	try:
		#print item.contents[1].find_all("span",{"itemprop": "address"})[0].text
		print item.contents[1].find_all("span",{"itemprop": "postalCode"})[0].text
	except:
		pass
	try:
		print item.contents[1].find_all("li",{"class": "primary"})[0].text
	except:
		pass
