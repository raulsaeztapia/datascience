-- select A.docid, B.docid, sum(A.count * B.count) as similarity from new_frequency A join new_frequency B on A.term = B.term where A.docid = 'q' and B.docid != 'q' group by A.docid, B.docid order by similarity desc limit 5
select sum(A.count * B.count) as similarity from new_frequency A join new_frequency B on A.term = B.term where A.docid = 'q' and B.docid != 'q' group by A.docid, B.docid order by similarity desc limit 1;
