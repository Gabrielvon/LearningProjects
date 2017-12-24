
# coding: utf-8

# In[18]:

from KaggleWord2VecUtility import KaggleWord2VecUtility
from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np
import scipy
from sklearn.linear_model import SGDClassifier
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import confusion_matrix


# In[2]:

import pandas as pd

# Read data from files 
article = pd.read_csv( "train_trend_1.csv")
article_test = pd.read_csv( "test_trend_1.csv")


# In[3]:

article_test


# In[4]:

print "Parsing train reviews..."

opinions = []
for opinion in article['Articles']:
    opinions.append( " ".join( KaggleWord2VecUtility.review_to_wordlist( opinion )))


# In[5]:

print "Parsing test reviews..."

opinions_test = []
for opinion_test in article_test['Articles']:
    opinions_test.append( " ".join( KaggleWord2VecUtility.review_to_wordlist( opinion_test )))


# In[8]:

##countVectorizer
print "Creating the bag of words...\n"
from sklearn.feature_extraction.text import CountVectorizer

# Initialize the "CountVectorizer" object, which is scikit-learn's
# bag of words tool.  
vectorizer = CountVectorizer(analyzer = "word", tokenizer = None, preprocessor = None,stop_words = None, max_features = 5000) 

# fit_transform() does two functions: First, it fits the model
# and learns the vocabulary; second, it transforms our training data
# into feature vectors. The input to fit_transform should be a list of 
# strings.
train_data_features = vectorizer.fit_transform(opinions)

# Numpy arrays are easy to work with, so convert the result to an 
# array
train_data_features = train_data_features.toarray()


# In[9]:

###count shape
train_data_features.shape


# In[10]:

train_data_features[1]


# In[11]:

###count feature names
vocab = vectorizer.get_feature_names()
print vocab


# In[12]:

print "Vectorizing..."

vectorizer = TfidfVectorizer( min_df=2, max_df=0.95, max_features = 200000, ngram_range = ( 1, 3 ),
                              sublinear_tf = True )

vectorizer = vectorizer.fit(opinions)
features = vectorizer.transform( opinions )
features_test = vectorizer.transform( opinions_test )


# In[13]:

print "Reducing dimension..."

from sklearn.feature_selection.univariate_selection import SelectKBest, chi2, f_classif
fselect = SelectKBest(chi2, k=10000)


# In[14]:

train_data_features = fselect.fit_transform(features, article["trend"])
test_data_features = fselect.transform(features_test)


# # Train the model

# In[128]:

print "Training..."

model1 = MultinomialNB(alpha=0.0005)
model1.fit( train_data_features, article["trend"] )

model2 = SGDClassifier(loss='modified_huber', n_iter=5, random_state=0, shuffle=True)
model2.fit( train_data_features, article["trend"] )


# In[129]:

p1 = model1.predict_proba( test_data_features )
output1 = pd.DataFrame(p1)
p1_1 = model1.predict(test_data_features)
output1 ['class'] = pd.Series(p1_1 , index=output1.index)


p2 = model2.predict_proba( test_data_features )
output2 = pd.DataFrame(p2)
p2_1 = model2.predict(test_data_features)
output2 ['class'] = pd.Series(p2_1 , index=output2.index)


# In[130]:

print "Writing results..."

output1.to_csv( "TF-IDF_NB.csv",index = False, quoting = 3 )
output2.to_csv( "TF-IDF_SGD.csv",index = False, quoting = 3 )


# In[131]:

p3 = model1.predict_proba( train_data_features )
output3 = pd.DataFrame(p3)
p3_1 = model1.predict(train_data_features)
output3 ['class'] = pd.Series(p3_1 , index=output3.index)

p4 = model2.predict_proba( train_data_features )
output4 = pd.DataFrame(p4)
p4_1 = model2.predict(train_data_features)
output4 ['class'] = pd.Series(p4_1 , index=output4.index)


# In[132]:

print "Writing results..."

output3.to_csv( "TF-IDF_NB_train.csv",index = False, quoting = 3 )
output4.to_csv( "TF-IDF_SGD_train.csv",index = False, quoting = 3 )


# In[23]:

# Fit a random forest to the training data, using 100 trees
from sklearn.ensemble import RandomForestClassifier
forest = RandomForestClassifier( n_estimators = 100 )

print "Fitting a random forest to labeled training data..."
forest = forest.fit( train_data_features, article["trend"] )

# Test & extract results 
result_testing = forest.predict( test_data_features )
result_training = forest.predict( train_data_features )


# In[16]:

testing_y = pd.read_csv("y_trend_1.csv")
training_y = pd.read_csv("train_trend_1.csv")


# In[19]:

cm_testing = confusion_matrix(testing_y,result_testing)
print(cm_testing)
accuracy_testing = (cm_testing[0,0]+cm_testing[1,1])/float(sum(sum(cm_testing)))
print accuracy_testing 


# In[25]:

cm_training = confusion_matrix(training_y['trend'], result_training)
print(cm_training)
accuracy_training = (cm_training[0,0]+cm_training[1,1])/float(sum(sum(cm_training)))
print accuracy_training


# In[ ]:



