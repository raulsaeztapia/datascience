import MapReduce
import sys

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # index 1: order_id
    order_id = record[1]

    mr.emit_intermediate(order_id, record)

def reducer(key, list_of_values):
    # key: order_id
    # value: row

    order_row = []
    result_row = []
    for row in list_of_values:
        if row[0] == "order":
            order_row = row
            appendAttributes(row, result_row)
        elif row[0] != "order":
            appendAttributes(row, result_row)

            mr.emit((result_row))
            result_row = []
            appendAttributes(order_row, result_row)

# Do not modify below this line
# =============================


def appendAttributes(item, result):

    for attribute in item:
        result.append(attribute)



if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
