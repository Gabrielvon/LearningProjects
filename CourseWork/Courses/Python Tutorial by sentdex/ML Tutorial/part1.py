# In this file, I learned the followings
# 1. download data using quandl
# 2. a bit of pandans data.frame
# 3. sklearn: train_test_split, linear.regression
# 4. use pickle to save a unit
# 5. with..as 
# 6. datetime and timestamps
# 7. matplotlib

import pandas as pd 
import quandl, math, datetime, time
import numpy as np
from sklearn import preprocessing, cross_validation, svm
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt
from matplotlib import style
import pickle

style.use('ggplot')

df = quandl.get('WIKI/GOOGL')
df = df[['Adj. Open','Adj. High','Adj. Low','Adj. Close','Adj. Volume']]
df['HL_PCT'] = (df['Adj. High'] - df['Adj. Close']) / df['Adj. Close'] * 100.0
df['PCT_change'] = (df['Adj. Close'] - df['Adj. Open']) / df['Adj. Open'] * 100.0


df = df[['Adj. Close','HL_PCT','PCT_change','Adj. Volume']]

forecast_col = 'Adj. Close'

# http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.fillna.html
df.fillna(-99999, inplace=True)

# Return the ceiling of x as a float, the smallest integer value greater than or equal to x.
forecast_out = int(math.ceil(0.01*len(df)))

# http://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.shift.html
df['label'] = df[forecast_col].shift(-forecast_out)


X = np.array(df.drop(['label'],1))
X = preprocessing.scale(X)
X = X[:-forecast_out]
X_lately = X[-forecast_out:]

df.dropna(inplace=True)
y = np.array(df['label'])

X_train, X_test, y_train, y_test = cross_validation.train_test_split(X, y, test_size=.2)

# clf = svm.SVR(kernel='poly')
clf = LinearRegression(n_jobs=-1)
clf.fit(X_train, y_train)
# with open('linearregression.pickle','wb') as f:
# 	pickle.dump(clf, f)

# pickle_in = open('linearregression.pickle','rb')
# clf = pickle.load(pickle_in)

accuracy = clf.score(X_test, y_test)
forecast_set = clf.predict(X_lately)
print(forecast_set, accuracy, forecast_out)
df['Forecast'] = np.nan

last_date = df.iloc[-1].name
last_unix = time.mktime(last_date.timetuple())
one_day = 86400 # seconds
next_unix = last_unix + one_day

for i in forecast_set:
	next_date = datetime.datetime.fromtimestamp(next_unix)
	next_unix += one_day
	df.loc[next_date] = [np.nan for _ in range(len(df.columns)-1)] + [i]

df['Adj. Close'].plot()
df['Forecast'].plot()
plt.legend(loc=4)
plt.xlabel('Date')
plt.ylabel('Price')
plt.show()

