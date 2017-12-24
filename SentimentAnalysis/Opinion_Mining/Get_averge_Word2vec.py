
# coding: utf-8

# In[ ]:

from KaggleWord2VecUtility import KaggleWord2VecUtility
from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np
import scipy
from sklearn.linear_model import SGDClassifier
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
from gensim.models import word2vec


# In[ ]:

import pandas as pd

# Read data from files 
article = pd.read_csv( "train_trend_1.csv")
article_test = pd.read_csv( "test_trend_1.csv")


# In[ ]:

print "Parse train reviews Done"

opinions = []
for opinion in article['Articles']:
    opinions.append( " ".join( KaggleWord2VecUtility.review_to_wordlist( opinion )))


# In[ ]:

print "Parse test reviews Done"

opinions_test = []
for opinion_test in article_test['Articles']:
    opinions_test.append( " ".join( KaggleWord2VecUtility.review_to_wordlist( opinion_test )))


# In[ ]:

# Download the punkt tokenizer for sentence splitting
import nltk.data
# Load the punkt tokenizer
tokenizer = nltk.data.load('tokenizers/punkt/english.pickle')

# Define a function to split a review into parsed sentences
def review_to_sentences( review, tokenizer, remove_stopwords=False ):
    # Function to split a review into parsed sentences. Returns a 
    # list of sentences, where each sentence is a list of words
    #
    # 1. Use the NLTK tokenizer to split the paragraph into sentences
    raw_sentences = tokenizer.tokenize(review.strip())
    #
    # 2. Loop over each sentence
    sentences = []
    for raw_sentence in raw_sentences:
        # If a sentence is empty, skip it
        if len(raw_sentence) > 0:
            # Otherwise, call review_to_wordlist to get a list of words
            sentences.append( KaggleWord2VecUtility.review_to_wordlist( raw_sentence,               remove_stopwords ))
    #
    # Return the list of sentences (each sentence is a list of words,
    # so this returns a list of lists
    return sentences


# In[ ]:

sentences = []  # Initialize an empty list of sentences

print "Parsing sentences from training set"
for review in opinions:
    sentences += review_to_sentences(review.decode("utf8"), tokenizer)

print "Parsing sentences from unlabeled set"
for review in opinions_test:
    sentences += review_to_sentences(review.decode("utf8"), tokenizer)


# In[ ]:

len(sentences)


# In[ ]:

sentences[0]


# In[ ]:

# Import the built-in logging module and configure it so that Word2Vec 
# creates nice output messages
import logging
logging.basicConfig(format='%(asctime)s : %(levelname)s : %(message)s',    level=logging.INFO)

# Set values for various parameters
num_features = 800    # Word vector dimensionality                      
min_word_count = 50   # Minimum word count                        
num_workers = 4       # Number of threads to run in parallel
context = 10          # Context window size                                                                                    
downsampling = 1e-3   # Downsample setting for frequent words

# Initialize and train the model (this will take some time)

print "Training model..."
model = word2vec.Word2Vec(sentences, workers=num_workers, size=num_features, min_count = min_word_count, window = context, sample = downsampling)

# If you don't plan to train the model any further, calling 
# init_sims will make the model much more memory-efficient.
model.init_sims(replace=True)

# It can be helpful to create a meaningful model name and 
# save the model for later use. You can load it later using Word2Vec.load()
model_name = "800features_50minwords_10context"
model.save(model_name)


# In[ ]:

model.doesnt_match("man woman child kitchen".split()) 


# In[ ]:

model.most_similar("man")


# In[ ]:

model.most_similar("queen")


# In[ ]:

model.most_similar("awful")


# In[ ]:

import numpy as np  # Make sure that numpy is imported

def makeFeatureVec(words, model, num_features):
    # Function to average all of the word vectors in a given
    # paragraph
    #
    # Pre-initialize an empty numpy array (for speed)
    featureVec = np.zeros((num_features,),dtype="float32")
    #
    nwords = 0.
    # 
    # Index2word is a list that contains the names of the words in 
    # the model's vocabulary. Convert it to a set, for speed 
    index2word_set = set(model.index2word)
    #
    # Loop over each word in the review and, if it is in the model's
    # vocaublary, add its feature vector to the total
    for word in words:
        if word in index2word_set: 
            nwords = nwords + 1.
            featureVec = np.add(featureVec,model[word])
    # 
    # Divide the result by the number of words to get the average
    featureVec = np.divide(featureVec,nwords)
    return featureVec


def getAvgFeatureVecs(reviews, model, num_features):
    # Given a set of reviews (each one a list of words), calculate 
    # the average feature vector for each one and return a 2D numpy array 
    # 
    # Initialize a counter
    counter = 0.
    # 
    # Preallocate a 2D numpy array, for speed
    reviewFeatureVecs = np.zeros((len(reviews),num_features),dtype="float32")
    # 
    # Loop through the reviews
    for review in reviews:
        #
        # Print a status message every 1000th review
        if counter%1000. == 0.:
            print "Review %d of %d" % (counter, len(reviews))
        # 
        # Call the function (defined above) that makes average feature vectors
        reviewFeatureVecs[counter] = makeFeatureVec(review, model, num_features)
        #
        # Increment the counter
        counter = counter + 1.
    return reviewFeatureVecs


# In[ ]:

num_features =800
#model = Word2Vec.load("800features_50minwords_10context")


# In[ ]:

trainDataVecs = getAvgFeatureVecs( opinions, model, num_features )


# In[ ]:

testDataVecs = getAvgFeatureVecs( opinions_test, model, num_features)


# In[ ]:




# # Train the model

# In[ ]:

len(trainDataVecs )


# In[ ]:

# Fit a random forest to the training data, using 100 trees
from sklearn.ensemble import RandomForestClassifier
forest = RandomForestClassifier( n_estimators = 100 )

print "Fitting a random forest to labeled training data..."
forest = forest.fit( trainDataVecs, article["trend"]  )

# Test & extract results 
result_testing = forest.predict( testDataVecs )
result_training = forest.predict( trainDataVecs )


# In[ ]:

testing_y = pd.read_csv("y_trend_1.csv")
training_y = pd.read_csv("train_trend_1.csv")


# In[ ]:

cm_testing = confusion_matrix(testing_y,result_testing)
print(cm_testing)
accuracy_testing = (cm_testing[0,0]+cm_testing[1,1])/float(sum(sum(cm_testing)))
print accuracy_testing 


# In[ ]:

cm_training = confusion_matrix(training_y['trend'], result_training)
print(cm_training)
accuracy_training = (cm_training[0,0]+cm_training[1,1])/float(sum(sum(cm_training)))
print accuracy_training


# In[ ]:




# In[ ]:




# In[ ]:




# In[ ]:



