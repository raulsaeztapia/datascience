select count(*) from Frequency f1 inner join Frequency f2 on f1.docid = f2.docid where f1.term = 'transactions' and f2.term = 'world';
