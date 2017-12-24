from time import sleep
from multiprocessing import Process, Value, Lock

def counter(c,l):
	# without lock, you may not get the same answer consistently
	for i in range(10):
		sleep(.5)
		l.acquire()
		c.value += 1
		l.release()

	return 0

if __name__ == '__main__':
	v = Value('i', 0)	#create a value zero that is integer
	l = Lock()
	p1 = Process(target=counter, args=(v,l))
	p2 = Process(target=counter, args=(v,l))
	p1.start()
	p2.start()
	p1.join()
	p2.join()
	print(v.value)