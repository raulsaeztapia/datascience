import MapReduce
import sys

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: tripleta with table, row and column
    # value: value
    table = record[0]
    row = record[1]
    column = record[2]
    value = record[3]
    
    tupla = (row, column, value)

    mr.emit_intermediate(table, tupla)

def reducer(key, list_of_values):
    # key: tripleta with table, row and column
    # value: value for this matrix position
#    row = 0
#    column = 0
#    if 'a' in key:
#        new_matrix = []
#        for entry in sorted(set(list_of_values)):
#            row = entry[0]
#            column = entry[1]
#            tupla = (row, column)
#            new_matrix = [[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]]
#
## now iterate b values
#            print (row, column)
#            values_of_b = mr.intermediate['b']
#
#            col = int(0)
#            while col < len(new_matrix):
#                for entry_aux in values_of_b:
#                    if entry_aux[0] == column and entry_aux[1] == row:
#                        new_matrix[row][column] += entry[2] * entry_aux[2]
#
#                print new_matrix
#                col = col +1

    if 'a' in key:
        tuplas_a = mr.intermediate['a']
        tuplas_b = mr.intermediate['b']

        table_a = [[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]]
        for tupla in tuplas_a:
            table_a[tupla[0]][tupla[1]] = tupla[2]

        table_b = [[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]]
        for tupla in tuplas_b:
            table_b[tupla[0]][tupla[1]] = tupla[2]

        result = [[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]]

        for row_a in range(0, len(result)):

            for col_b in range(0, len(result)):

                summ = int(0)
                for col_a in range(0, len(result)):

                    try:
                        summ = summ + (table_a[row_a][col_a] * table_b[col_a][col_b])
                    except IndexError:
                        summ = summ + 0


                mr.emit((row_a, col_b, summ))
                col_b = col_b + 1


# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)
