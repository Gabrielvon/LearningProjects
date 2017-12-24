# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')

import re
# text_file = open('regex_sum_sample.rtf').read()
text_file = open('regex_sum_actual.rtf').read()
lines = text_file.split()
linenum = 0
for sent in lines:
	linenum += 1
	first = re.search('This',sent)
	if first:
		num = linenum
		break

mysum = 0
for sent in lines[num-1:]:	
	digits = re.findall('[0-9]+',sent)
	if len(digits)>0:
		mysum += int(digits[0])

print mysum