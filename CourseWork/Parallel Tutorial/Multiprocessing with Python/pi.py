
from random import random
from math import sqrt, pi
from multiprocessing import Pool

def coumpute_pi(n):
	i, inside = 0, 0
	while i < n:
		x = random()
		y = random()
		if sqrt(x*x + y*y) <= 1:
			inside += 1
		i += 1
	ratio = 4.0 * inside / n
	return ratio

if __name__ == '__main__':
	p = Pool(1)
	pis = p.map(coumpute_pi, [10000000] * 4)	
	print(pis)
	mypi = sum(pis)/4.0
	print("My pi: {0}, Error: {1}".format(mypi, mypi-pi))