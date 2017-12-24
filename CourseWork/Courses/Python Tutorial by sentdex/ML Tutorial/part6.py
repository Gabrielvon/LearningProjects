## not finished, cannot find the original script
## learnt from Soft Margin SVM and Kernels with CVXOPT -Pratcal Machine LEarning p32 by sentdex on Youtube
## Mainly talk about CVXOPT

import numpy as np
from numpy import linalg
import cvxopt
import cvxopt.solvers

def linear_kernel(x1, x2):
	return np.dot(x1, x2)

def polynomial_kernel(x, y, p=3):
	return (1 + np.dot(x, y)) ** p

def gaussian_kernel(x, y, sigma=5.0):
	return np.exp(-linalg.norm(x-y)**2 / (2 * (sigma ** 2)))

class SVM(object):

	def __init__(self, kernel=linear_kernel, C=None):
		self.kernel = kernel
		self.C = C
		if self.C is not None: self.C = float(self.C)

	def fit(self, X, y):
		n_samples, n_features = X.shape

		# Gram matrix
		K = np.zeros((n_samples, n_samples))
		for i in range(n_samples):
			for j in range(n_samples):
				K[i, j] = self.kernel(X[i], X[j])

		p = cvxopt.matrix(np.outer(y,y) * K)
		q = cvxopt.matrix(np.ones(n_samples) * -1)
		A = cvxopt.matrix(y, (1, n_samples))
		b = cvxopt.matrix(0 , 0)

		if self.C is None:
			G = cvxopt.matrix(np.diag(np.ones(n_samples) * -1))
			h = cvxopt.matrix(np.zeros(n_samples))
		else:
			tmp1 = np.diag(np.ones(n_samples) * -1)
			tmp2 = np.identity(n_samples)
			G = cvxopt.matrix(np.vstack((tmp1, tmp2)))
			tmp1 = np.zeros(n_samples)
			tmp2 = np.ones(n_samples) * self.C
			h = cvxopt.matrix(np.hstack(tmp1, tmp2))

		# solve QP problem
		solution = cvxopt.solvers.qp(P, q, G, h, A, b)	

		# Lagrange multipliers
		a = np.ravel(solution['x'])

		# Support vectors have non zero lagrange multipliers
		sv = a > 1e-5
		ind = np.arange(len(a))[sv]
		self.a = a[sv]
		self.sv = X[sv]
		self.sv_y = y[sv]
		print("%d support vectors out of %d points" % (len(self.a), n_samples))

		# Intercept
		self.b = 0
		for n in range(len(self.a)):
			self.b += self.sv_y[n]
			self.b -= np.sum(self.a * self.sv_y * K[ind[n],sv])
		self.b /= len(self.a)	

		# Weight vector
		if self.kernel == linear_kernel:
			self.w = np.zeros(n_features)
			for n in range(len(self.a)):
				self.w += self.a[n] * self.sv_y[n] * self.sv[n]
		else:
			self.w = None

	def project(self, X):
		pass

	def predict(self, X):
		pass
	

if __name__ == "__main__"			:
	import pylab as pylab
	def gen_lin_separable_data():
		return


	def gen_non_lin_separable_data():
		return	


	def gen_lin_separable_overlap_data():
		# generate training data in the 2-d case
		return

	def split_train(X1, y1, X2, y2):	
		return

	def plot_margin():
		pass








