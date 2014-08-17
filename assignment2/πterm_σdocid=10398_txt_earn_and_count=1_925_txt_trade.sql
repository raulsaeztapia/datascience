select count(*) from (select term from Frequency f1 where f1.docid='10398_txt_earn' and f1.count=1 group by term UNION select term from Frequency f2 where f2.docid='925_txt_trade' and f2.count=1 group by term);
--select count(distinct(term)) from Frequency f1 where (f1.docid='10398_txt_earn' or f1.docid='925_txt_trade') and f1.count=1;
