# Sentiment-Analysis

Text scrape and mining were done in Python


MTS analysis was done in R.

--------------------------------------------------------------------------------------------------------------------------

For the text mining project, I was initiated by the idea sentiment analysis which I am interested in. I want to learn this method so I took AAPL as an example and proceed the project. The reason for choosing AAPL is active users comment on Apple’s product which mean there should be lots of text data on the internet relative to Apple. Basically, I separated this project into five steps as follows.

1. Data collection: 
	1) Collect numeric data, such as AAPL stock price and relative 	macroeconomic data, such as currency, oil, vix, from Bloomberg Excel API. 
	2) Collect text data from internet. In the beginning, I mainly tried using twitter twits but the number of twits is enormous  and there is limits for download using twitter API so that I cannot cover 5 years which is our study range. As a result, I changed my strategy to use financial news and product reviews instead. In the end , I collected over 10,000 news and reviews were collected and over 40megabytes.

2. Data Processing and cleaning
	1) Remove duplicates for text data
	2) Concatenate all articles in one day, and tokenized articles into vectors and generated features by day using two methods: TF-IDF, Word2Vec algorithm developed by Google.

3. Multivariate Analysis
	1) Only study the numeric for reviewing time series knowledge
	2) No any results, so we decided to use stock price only.

4. Based on machine learning knowledge, we need to classify the numeric data. What we do is to only considering up and down, for the price going up[1] or going down[0] respectively.

5. Machine Learning Analysis
	1) Match the features with price classifiers [0, 1] by date
	2) Separate into training set and test set
	3) Train data use Kmean, Random forest, Naive bayers, SGD

Honestly, I did this project with two other student who study marketing research. None of us are expert in programming and have ever done similar projects. However, while learning by doing, we did it and learnt a lot and so quick. Check the final result for our project via my GitHub. Please feel free to ask any questions.

Result: https://github.com/Gabrielvon/Text-Mining
Whole project files: https://github.com/Gabrielvon/Sentiment-Analysis

