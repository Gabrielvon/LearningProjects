####################################
####################################
# Writing our own K Nearest Neighbors

import numpy as np
from math import sqrt
import matplotlib.pyplot as plt
from matplotlib import style
import warnings, random
import pandas as pd
from collections import Counter
from sklearn import preprocessing, cross_validation, neighbors

style.use('fivethirtyeight')


def k_nearest_neighbors(data, predict, k=3):
	if len(data) >= k:
		warnings.warn(('K is set to a value less than total voting groups!'))

	distances = []
	for group in data:
		for features in data[group]:
			# euclidean_distance = sqrt ( (features[0]-predict[0])**2 + (features[1]-predict[1])**2 ) #only for two-dimension
			euclidean_distance = np.linalg.norm(np.array(features)-np.array(predict)) #faster and able to do high-dimension
			distances.append([euclidean_distance, group])

	votes = [i[1] for i in sorted(distances)[:k]]
	vote_result = Counter(votes).most_common(1)[0][0]	
	confidence = float(Counter(votes).most_common(1)[0][1]) / k

	return vote_result, confidence

accuracies = []
for i in range(25):
	df = pd.read_csv("breast-cancer-wisconsin.data.txt")
	df.replace('?', -99999, inplace=True)
	df.drop(['id'], 1, inplace=True)

	full_data = df.astype(float).values.tolist() #convert to float and list.
	random.shuffle(full_data)

	test_size = 0.4
	train_set = { 2:[], 4:[] } #creat a dict that concludes two lists with different names 
	test_set = { 2:[], 4:[] } #creat a dict that concludes two lists with different names 
	train_data = full_data[:-int(test_size*len(full_data))]
	test_data = full_data[-int(test_size*len(full_data)):]

	for i in train_data:	
		train_set[i[-1]].append(i[:-1])
	for i in test_data:
		test_set[i[-1]].append(i[:-1])

	correct = 0
	total = 0

	for group in test_set:
		for data in test_set[group]:
			vote, confidence = k_nearest_neighbors(train_set, data, k=5)
			if group == vote:
				correct += 1
			total += 1

	# print('Accuracy:', float(correct)/total)
	accuracies.append(float(correct)/total)

print sum(accuracies)/len(accuracies)



####################################
## Applied KNN via sklearn and compared with your own KNN algo
accuracies = []
for i in range(25):
	df = pd.read_csv("breast-cancer-wisconsin.data.txt")
	df.replace('?', -99999, inplace=True)
	df.drop(['id'], 1, inplace=True)

	X = np.array(df.drop(['class'],1))
	y = np.array(df['class'])

	X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y,test_size=0.2)

	clf = neighbors.KNeighborsClassifier()
	clf.fit(X_train, y_train)

	accuracy = clf.score(X_test, y_test)
	accuracies.append(accuracy)
	print accuracy,
print "\nAverage: ", sum(accuracies)/len(accuracies)

# prediction = clf.predict()





