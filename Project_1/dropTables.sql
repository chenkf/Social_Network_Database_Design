-- first, delete children table
DROP TABLE FRIENDS;

DROP TABLE USER_CURRENT_CITY;

DROP TABLE USER_HOMETOWN_CITY;

DROP TABLE EDUCATION;

DROP TABLE Messages;
DROP TABLE Photos;
DROP TABLE Albums;
DROP TABLE Tags;


-- then, delete parent tables (or we can use CASCADE CONSTRAINTS )
DROP TABLE USERS;

DROP TABLE CITIES;

DROP TABLE PROGRAMS;





