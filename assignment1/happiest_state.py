import json
import sys
states = {
        'AK': ('Alaska', 0),
        'AL': ('Alabama', 0),
        'AR': ('Arkansas', 0),
        'AS': ('American Samoa', 0),
        'AZ': ('Arizona', 0),
        'CA': ('California', 0),
        'CO': ('Colorado', 0),
        'CT': ('Connecticut', 0),
        'DC': ('District of Columbia', 0),
        'DE': ('Delaware', 0),
        'FL': ('Florida', 0),
        'GA': ('Georgia', 0),
        'GU': ('Guam', 0),
        'HI': ('Hawaii', 0),
        'IA': ('Iowa', 0),
        'ID': ('Idaho', 0),
        'IL': ('Illinois', 0),
        'IN': ('Indiana', 0),
        'KS': ('Kansas', 0),
        'KY': ('Kentucky', 0),
        'LA': ('Louisiana', 0),
        'MA': ('Massachusetts', 0),
        'MD': ('Maryland', 0),
        'ME': ('Maine', 0),
        'MI': ('Michigan', 0),
        'MN': ('Minnesota', 0),
        'MO': ('Missouri', 0),
        'MP': ('Northern Mariana Islands', 0),
        'MS': ('Mississippi', 0),
        'MT': ('Montana', 0),
        'NA': ('National', 0),
        'NC': ('North Carolina', 0),
        'ND': ('North Dakota', 0),
        'NE': ('Nebraska', 0),
        'NH': ('New Hampshire', 0),
        'NJ': ('New Jersey', 0),
        'NM': ('New Mexico', 0),
        'NV': ('Nevada', 0),
        'NY': ('New York', 0),
        'OH': ('Ohio', 0),
        'OK': ('Oklahoma', 0),
        'OR': ('Oregon', 0),
        'PA': ('Pennsylvania', 0),
        'PR': ('Puerto Rico', 0),
        'RI': ('Rhode Island', 0),
        'SC': ('South Carolina', 0),
        'SD': ('South Dakota', 0),
        'TN': ('Tennessee', 0),
        'TX': ('Texas', 0),
        'UT': ('Utah', 0),
        'VA': ('Virginia', 0),
        'VI': ('Virgin Islands', 0),
        'VT': ('Vermont', 0),
        'WA': ('Washington', 0),
        'WI': ('Wisconsin', 0),
        'WV': ('West Virginia', 0),
        'WY': ('Wyoming', 0)
}
scores = {} # initialize an empty dictionary
tweets = {} # initialize an empty list

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
                if tweet_decode['lang'] == "en":
                    if getCountry(tweet_decode) == "US":
                        location = getLocation(tweet_decode)
                        if location:
                            #print location
# get key for state
                            for state in states:
                                if states[state][0].lower() in location.lower() :
# new positive for a state
                                    tupla = states[state]
                                    tupla_aux = (tupla[0], tupla[1] + 1)
                                    states[state] = tupla_aux
                                    if state in tweets:
                                        tweets[state] += calculateScoreByText(tweet_decode['text'])
                                    else:
                                        tweets[state] = calculateScoreByText(tweet_decode['text'])



def calculateScoreByText(text):

    score = 0

    for word in text.split(" "):
        if word in scores:
            score += scores[word]

    return score


def getCountry(tweet):

    if tweet['place']:
        return tweet['place']['country_code']


def getLocation(tweet):

    if tweet['user']:
        if tweet['user']['location']:
            return tweet['user']['location']



def calculateAverageByState(state, scoreByState):

    #print state + " " + str(states[state]) + " " + str(scoreByState)
    return scoreByState / states[state][1]


def evaluateHighestAverage():

    first_tweet_state = tweets.items()[0][0]
    second_tweet_state = tweets.items()[0][1]
    highest = [first_tweet_state, calculateAverageByState(first_tweet_state, second_tweet_state)]

    for key in tweets:  # Print every tweets in the list
        averageByState = calculateAverageByState(key, tweets[key])
        if averageByState > highest[1]:
            highest[0] = key
            highest[1] = averageByState

    print highest[0]



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

# print highest average tweet by state
    evaluateHighestAverage()


if __name__ == '__main__':
    main()
