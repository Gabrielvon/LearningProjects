
# coding: utf-8

# In[6]:

from KaggleWord2VecUtility import KaggleWord2VecUtility
import numpy as np
from sklearn.metrics import confusion_matrix


# In[7]:

from gensim.models import Word2Vec
model = Word2Vec.load("800features_50minwords_10context")


# In[8]:

from sklearn.cluster import KMeans
import time

start = time.time() # Start time

# Set "k" (num_clusters) to be 1/5th of the vocabulary size, or an
# average of 5 words per cluster
word_vectors = model.syn0
num_clusters = word_vectors.shape[0] / 5
# Initalize a k-means object and use it to extract centroids
kmeans_clustering = KMeans( n_clusters = num_clusters )
idx = kmeans_clustering.fit_predict( word_vectors )

# Get the end time and print how long the process took
end = time.time()
elapsed = end - start
print "Time taken for K Means clustering: ", elapsed, "seconds."


# In[9]:

# Create a Word / Index dictionary, mapping each vocabulary word to
# a cluster number                                                                                            
word_centroid_map = dict(zip( model.index2word, idx ))


# In[10]:

# For the first 10 clusters
for cluster in xrange(0,10):
    #
    # Print the cluster number  
    print "\nCluster %d" % cluster
    #
    # Find all of the words for that cluster number, and print them out
    words = []
    for i in xrange(0,len(word_centroid_map.values())):
        if( word_centroid_map.values()[i] == cluster ):
            words.append(word_centroid_map.keys()[i])
    print words


# In[11]:

def create_bag_of_centroids( wordlist, word_centroid_map ):
    #
    # The number of clusters is equal to the highest cluster index
    # in the word / centroid map
    num_centroids = max( word_centroid_map.values() ) + 1
    #
    # Pre-allocate the bag of centroids vector (for speed)
    bag_of_centroids = np.zeros( num_centroids, dtype="float32" )
    #
    # Loop over the words in the review. If the word is in the vocabulary,
    # find which cluster it belongs to, and increment that cluster count 
    # by one
    for word in wordlist:
        if word in word_centroid_map:
            index = word_centroid_map[word]
            bag_of_centroids[index] += 1
    #
    # Return the "bag of centroids"
    return bag_of_centroids


# In[12]:

import pandas as pd

# Read data from files 
article = pd.read_csv( "train_trend_1.csv")
article_test = pd.read_csv( "test_trend_1.csv")


# In[ ]:

print "Parsing train reviews..."

opinions = []
for opinion in article['Articles']:
    opinions.append( " ".join( KaggleWord2VecUtility.review_to_wordlist( opinion )))


# In[ ]:

print "Parsing test reviews..."

opinions_test = []
for opinion_test in article_test['Articles']:
    opinions_test.append( " ".join( KaggleWord2VecUtility.review_to_wordlist( opinion_test )))


# In[ ]:

# Pre-allocate an array for the training set bags of centroids (for speed)
train_centroids = np.zeros( (article['Articles'].size, num_clusters),     dtype="float32" )

# Transform the training set reviews into bags of centroids
counter = 0
for review in opinions:
    train_centroids[counter] = create_bag_of_centroids( review, word_centroid_map )
    counter += 1

# Repeat for test reviews 
test_centroids = np.zeros(( article_test['Articles'].size, num_clusters),     dtype="float32" )

counter = 0
for review in opinions_test:
    test_centroids[counter] = create_bag_of_centroids( review, word_centroid_map )
    counter += 1


# In[ ]:

# Fit a random forest and extract predictions
from sklearn.ensemble import RandomForestClassifier
forest = RandomForestClassifier(n_estimators = 100)

# Fitting the forest may take a few minutes
print "Fitting a random forest to labeled testing data..."
forest = forest.fit(train_centroids,article["trend"])
result_test = forest.predict(test_centroids)

result_train = forest.predict(train_centroids)

# Write the test results 
#output = pd.DataFrame(data={"id":test["id"], "sentiment":result})
#output.to_csv( "BagOfCentroids.csv", index=False, quoting=3 )


# In[ ]:

testing_y = pd.read_csv("y_trend_1.csv")
training_y = pd.read_csv("train_trend_1.csv")


# In[ ]:

cm_testing = confusion_matrix(testing_y,result_test)
print(cm_testing)
accuracy_testing = (cm_testing[0,0]+cm_testing[1,1])/float(sum(sum(cm_testing)))
print accuracy_testing 


# In[ ]:

cm_training = confusion_matrix(training_y['trend'], result_train)
print(cm_training)
accuracy_training = (cm_training[0,0]+cm_training[1,1])/float(sum(sum(cm_training)))
print accuracy_training


# In[ ]:



