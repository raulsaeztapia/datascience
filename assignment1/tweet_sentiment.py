import json
import sys

scores = {} # initialize an empty dictionary
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

    for text in tweets:  # Print every tweets in the list
        print text
#    print tweets[201] # Print every tweets in the list
#    print tweets[330] # Print every tweets in the list
#    print tweets[331] # Print every tweets in the list
#    print tweets[1000] # Print every tweets in the list


def calculateScoreByText(text):

    score = 0

    for word in text.split(" "):
        if word in scores:
            score += scores[word]

    return score


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


if __name__ == '__main__':
    main()
