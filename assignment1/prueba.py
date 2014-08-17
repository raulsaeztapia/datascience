import string
import sys

def main():

    text = ".goma_"
    print text.strip(string.punctuation)

if __name__ == '__main__':
    main()

