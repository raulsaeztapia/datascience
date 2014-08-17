SELECT SUM(A.value * B.value) FROM A, B WHERE A.col_num = B.row_num and A.row_num = 2 and B.col_num = 3 GROUP BY A.row_num, B.col_num;
