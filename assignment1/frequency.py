import json
import string
import sys

terms = {} # initialize an empty dictionary
all_ocurrences_all_tweets = 0

def lines(fp):
    print str(len(fp.readlines()))


def termsCount(tf):

    with open(tf) as tweet_file:
        for line in tweet_file:
            tweet_decode = json.loads(line)
            #print tweet_decode
            if 'created_at' in tweet_decode:
                countTerms(tweet_decode['text'])


def countTerms(text):

    for word_aux in text.split():
        word = word_aux.strip(string.punctuation)
        if word in terms:
            terms[word] += float(1)
        else:
            terms[word] = float(1)

        global all_ocurrences_all_tweets
        all_ocurrences_all_tweets += 1



def main():

# asignment of arguments
    tweet_file = open(sys.argv[1])

# we count lines of each file
#    lines(sent_file)
#    lines(tweet_file)

# iterate tweets dictionary and evaluate it score
    termsCount(sys.argv[1])

# print stdout frequency of terms on tweets
    for key in terms:
        frequency = terms[key] / all_ocurrences_all_tweets
#        aux = key + " {:.7f}".format(frequency)
#        print aux.split()
        print key + " {:.7f}".format(frequency)


if __name__ == '__main__':
    main()

