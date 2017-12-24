import numpy as np
import pandas as pd
from sklearn import preprocessing, cross_validation, neighbors, svm

### Basic sklearn
df = pd.read_csv("breast-cancer-wisconsin.data.txt")
df.replace('?', -99999, inplace=True)
df.drop(['id'], 1, inplace=True)
X = np.array(df.drop(['class'],1))
y = np.array(df['class'])

X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y,test_size=0.2)
clf = svm.SVC()
clf.fit(X_train, y_train)

accuracy = clf.score(X_test, y_test)
print(accuracy)



##

# rbf: radio-based function
# SVM Parameter!!!  part33 by sentdex on Youtube