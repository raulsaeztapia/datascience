select count(*) from (select docid from Frequency f1 group by docid having sum(f1.count) > 300);
