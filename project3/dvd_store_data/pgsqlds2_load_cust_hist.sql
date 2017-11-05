-- ALTER TABLE CUST_HIST DISABLE TRIGGER ALL;

\COPY CUST_HIST FROM './data/orders/jan_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/feb_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/mar_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/apr_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/may_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/jun_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/jul_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/aug_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/sep_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/oct_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/nov_cust_hist.csv' WITH DELIMITER ',' 
\COPY CUST_HIST FROM './data/orders/dec_cust_hist.csv' WITH DELIMITER ',' 

-- ALTER TABLE CUST_HIST ENABLE TRIGGER ALL;
