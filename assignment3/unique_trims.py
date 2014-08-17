import MapReduce
import sys

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: identifier of sequence
    # value: sequence
    key = record[0]
    value = record[1]
# remove last 10 characters
    dna_substring = value[:-10]
    mr.emit_intermediate("default", dna_substring)

def reducer(key, list_of_values):
    # key: identifier of sequence
    # value: list of cut dna
    sequences = []
    for sequence in list_of_values:
        sequences.append(sequence)

    for sequence in set(sequences):
        mr.emit(sequence)

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
