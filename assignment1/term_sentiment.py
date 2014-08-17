import json
import string
import sys

scores = {} # initialize an empty dictionary
score_new_terms = {} # initialize an empty dictionary
tweets = [] # initialize an empty list

def lines(fp):
    print str(len(fp.readlines()))

def createSentimentsDictionary(sf):

    with open(sf) as sent_file:
        for line in sent_file:
            term, score  = line.split("\t")  # The file is tab-delimited. "\t" means "tab character"
            scores[term] = int(score)  # Convert the score to an integer.

    #print scores.items() # Print every (term, score) pair in the dictionary


def calculateScore(tf):

    with open(tf) as tweet_file:
        for line in tweet_file:
            tweet_decode = json.loads(line)
            #print tweet_decode
            if 'created_at' in tweet_decode:
                score = calculateScoreByText(tweet_decode['text'])
                tweets.append(score)
                calculateScoreByTexaNewTermst(tweet_decode['text'], score)

#    print tweets[201] # Print every tweets in the list
#    print tweets[330] # Print every tweets in the list
#    print tweets[331] # Print every tweets in the list
#    print tweets[1000] # Print every tweets in the list


def calculateScoreByText(text):

    score = 0

    for word_aux in text.split(" "):
        word = word_aux.strip(string.punctuation)
        if word in scores:
            score += scores[word]

    return score

# we calculate score of new terms summarizen on each new term the score of the tweet when calculate it score
def calculateScoreByTexaNewTermst(text, scoreOfTweet):

    for word_aux in text.split(" "):
        if word_aux not in scores:
            word = word_aux.strip(string.punctuation)
            if word in score_new_terms:
                score_new_terms[word] += scoreOfTweet
            else:
                score_new_terms[word] = float(scoreOfTweet)



def main():

# asignment of arguments
    sent_file = open(sys.argv[1])
    tweet_file = open(sys.argv[2])

# we count lines of each file
#    lines(sent_file)
#    lines(tweet_file)

# we generate a dictionary of sentiments
    createSentimentsDictionary(sys.argv[1])

# iterate tweets dictionary and evaluate it score
    calculateScore(sys.argv[2])

# print stdout score
#    for score_by_tweet in tweets:  # Print every tweets in the list
#        print score_by_tweet

# print stdout score of new terms
    for key in score_new_terms:
        print key + " " + repr(score_new_terms[key])

if __name__ == '__main__':
    main()
