from os import getpid
from multiprocessing import Process

def prove_existence():
	print(getpid())

if __name__ == '__main__':
	p = Process(target=prove_existence, args=())	
	p.start()
	p.join()
	p2 = Process(target=prove_existence, args=())
	p2.start()
	p2.join()