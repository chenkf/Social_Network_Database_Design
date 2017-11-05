-- ALTER TABLE ORDERS DISABLE TRIGGER ALL;

\COPY ORDERS FROM './data/orders/jan_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/feb_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/mar_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/apr_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/may_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/jun_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/jul_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/aug_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/sep_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/oct_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/nov_orders.csv' WITH DELIMITER ',' 
\COPY ORDERS FROM './data/orders/dec_orders.csv' WITH DELIMITER ',' 

-- ALTER TABLE ORDERS ENABLE TRIGGER ALL;
