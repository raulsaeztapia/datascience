import json
import operator
import sys


hashtags = {} # initialize an empty list

def lines(fp):
    print str(len(fp.readlines()))


def createHashtagsDictionary(tf):

    with open(tf) as tweet_file:
        for line in tweet_file:
            tweet_decode = json.loads(line)
            #print tweet_decode
            if 'created_at' in tweet_decode:
                hashtags_aux = getHashtags(tweet_decode)
                for hashtag in  hashtags_aux:
                    if hashtag['text'] in hashtags:
                        hashtags[hashtag['text']] += 1
                    else:
                        hashtags[hashtag['text']] = 1


def getHashtags(tweet):

    if tweet['entities']:
        return tweet['entities']['hashtags']



def main():

# asignment of arguments
    tweet_file = open(sys.argv[1])

# we count lines of each file
#    lines(sent_file)
#    lines(tweet_file)

# iterate tweets
    createHashtagsDictionary(sys.argv[1])

# order hashtags by frequency
    sorted_hashtags_by_frequency = sorted(hashtags.iteritems(), key=operator.itemgetter(1), reverse=True)
# get only top ten hashtags
    index = 0
    for hashtag in sorted_hashtags_by_frequency:
        print hashtag[0] + " " + str(hashtag[1])
        index += 1
        if index == 10:
            break


if __name__ == '__main__':
    main()
