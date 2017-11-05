ALTER TABLE ORDERLINES DISABLE TRIGGER ALL;

\COPY ORDERLINES FROM './data/orders/jan_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/feb_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/mar_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/apr_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/may_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/jun_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/jul_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/aug_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/sep_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/oct_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/nov_orderlines.csv' WITH DELIMITER ','
\COPY ORDERLINES FROM './data/orders/dec_orderlines.csv' WITH DELIMITER ','

ALTER TABLE ORDERLINES ENABLE TRIGGER ALL;
