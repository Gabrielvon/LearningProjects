

# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import requests
from bs4 import BeautifulSoup
import re, time, traceback, csv

keywords = 'apple'


########----------Find the page ranges----------########
print time.asctime(), ":     Finding the page ranges"
statpage = 0
endpage = 0
statdate = r'Oct\w*\. 1, 2014' #'October 1, 2014'
enddate = r'Oct\w*\. 12, 2015' #'October 12, 2015'
for i in range(10000):
  page = i+1 #the first page for this website is 'o=001'
  url = 'http://www.marketwatch.com/search?q=%s&m=Keyword&rpp=100&mp=806&bd=false&rs=true&o=%d01' %(keywords,i)
  source_code = requests.get(url)
  content = source_code.content
  soup = BeautifulSoup(content,"html.parser")

  # Find pages
  g_data = soup.find_all('div',{'class':'resultlist'})

  #Start page
  if statpage == 0:
    for item in g_data:
      for tt in item.find_all('span'):
        datetext = tt.text

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
    for tt in item.find_all('span'):
      datetext = tt.text

      try:
        cdate2 = re.search(statdate,datetext).group()
        print cdate2
        endpage = page
        print 'Ending page = ', page
        break
      except:
        cdate2 = ""
        continue

    if endpage >= 1:
      break
  print endpage
  # if len(cdate1) >=1 & len(cdate2) >=1:
  if statpage >=1 & endpage >=1:
    print "Ending Page Got"
    break

print time.asctime(), ":     Page ranges is from "+str(statpage)+" to "+str(endpage)    
##################

########----------Crawling Part 1----------########
statpage = 1  #get from former part
endpage = 32  #get from former part
# endpage = 2
tol = 5
print time.asctime(), ":     Getting all links"

titles = []
links = []
flinks = open('mktwlinks_v1.csv','ab+')
for i in range(statpage-1,endpage+tol):
  page = i+1
  url = 'http://www.marketwatch.com/search?q=%s&m=Keyword&rpp=100&mp=806&bd=false&rs=true&o=%d01' %(keywords,i)
  source_code = requests.get(url)
  content = source_code.content
  soup = BeautifulSoup(content,"html.parser")

  l_data = soup.find_all('div',{'class':'resultlist'})


  for item in l_data:
    for ll in item.find_all('a'):
      # links.append(ll.contents[1].get('href'))
      link = ll.get('href')
      flinks.write(link+'\n')
      links.append(link)

print time.asctime(), ":     All links retrived"
###################


########----------Crawling Part 2----------########
ii = 0
fart = open('mktwart_v1.csv','ab+')
writer = csv.writer(fart)
writer.writerow(['Number','Datetime','Title','Url','Text'])
for link in links:
  try:
    source_code = requests.get(link)
    content = source_code.content
    soup = BeautifulSoup(content,"html.parser")

    g_data = soup.find_all('div',{'id':'article-body','itemprop':'articleBody'})
    oneart = []
    for item in g_data:
      for aa in item.find_all('p'):
        try:
          oneart.append(str(aa.text.encode('utf8').split()))
        except Exception,e:
          print 'oneart',e
          continue

    t_data = soup.find_all('div',{'class':'article-headline-wrapper'})
    try:
      for item in t_data:
        title = item.text.encode('utf8')
    except Exception,e:
      print 'title',e
      title = 'Not Available'

    data = soup.find_all('p',{'id':'published-timestamp'})
    date = []
    for item in data:
      datetext = str(item.text.strip())
      date.append(datetext)
      # print datetext
    print date
    pat = re.compile(r' .*')

    try:
      datetime = re.search(pat,str(date)).group().strip()
    except Exception,e:
      print 'datetime',e
      datetime = 'Not Available'

    ii += 1
    data = ["%d" %ii, datetime, title, link, oneart]
    writer.writerow(data)
    print '\n\n\n',link
    print 'Retrived Articles %d' %ii

  except Exception, e:
    datetime = re.search(r'(\d+/)+',link).group()
    ii += 1
    data = ["%d" %ii, datetime, title, link, str(e)]
    writer.writerow(data)
    print e
    continue

fart.close()
print '\nGet', ii, 'articles\n'
print time.asctime(), ':     All articles retrived and saved'
