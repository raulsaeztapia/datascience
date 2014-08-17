import MapReduce
import sys

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: personaA
    # value: personB
    key = record[0]
    value = record[1]
    mr.emit_intermediate(key, value)

def reducer(key, list_of_values):
    # key: personA
    # value: list of personB
#    for v in list_of_values:
#
#        # check if personB have to personA as friend
#        if v in mr.intermediate:
#            if key not in mr.intermediate[v]:
#                mr.emit((key, v))
#                mr.emit((v, key))
#        else:
#            mr.emit((key, v))
#            mr.emit((v, key))

    asyncs = []
    for v in list_of_values:

        # check if personB have to personA as friend
        if v in mr.intermediate:
            if key not in mr.intermediate[v]:
                asyncs.append(v)
        else:
            asyncs.append(v)

    for entry in asyncs:
        mr.emit((key, entry))
        mr.emit((entry, key))


# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
