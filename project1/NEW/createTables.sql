CREATE TABLE USERS (
	USER_ID NUMBER,
	FIRST_NAME VARCHAR2(100) NOT NULL,
	LAST_NAME VARCHAR2(100) NOT NULL,
	YEAR_OF_BIRTH INTEGER,
	MONTH_OF_BIRTH INTEGER,
	DAY_OF_BIRTH INTEGER,
	GENDER VARCHAR2(100),
	PRIMARY KEY (USER_ID)
);

CREATE TABLE FRIENDS (
	USER1_ID NUMBER,
	USER2_ID NUMBER,
	PRIMARY KEY (USER1_ID, USER2_ID),
	FOREIGN KEY (USER1_ID) REFERENCES USERS(USER_ID),
	FOREIGN KEY (USER2_ID) REFERENCES USERS(USER_ID),
	CHECK (USER1_ID <> USER2_ID)
);

CREATE TABLE CITIES (
	CITY_ID INTEGER,
	CITY_NAME VARCHAR2(100) NOT NULL,
	STATE_NAME VARCHAR2(100) NOT NULL,
	COUNTRY_NAME VARCHAR2(100) NOT NULL,
	PRIMARY KEY (CITY_ID),
	UNIQUE (CITY_NAME, STATE_NAME, COUNTRY_NAME)
);

CREATE TABLE USER_CURRENT_CITY (
	USER_ID NUMBER,
	CURRENT_CITY_ID INTEGER NOT NULL,
	PRIMARY KEY (USER_ID),
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
	FOREIGN KEY (CURRENT_CITY_ID) REFERENCES CITIES(CITY_ID)
);

CREATE TABLE USER_HOMETOWN_CITY (
	USER_ID NUMBER,
	HOMETOWN_CITY_ID INTEGER NOT NULL,
	PRIMARY KEY (USER_ID),
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
	FOREIGN KEY (HOMETOWN_CITY_ID) REFERENCES CITIES(CITY_ID)
);

CREATE TABLE PROGRAMS (
	PROGRAM_ID INTEGER,
	INSTITUTION VARCHAR2(100) NOT NULL,
	CONCENTRATION VARCHAR2(100) NOT NULL,
	DEGREE VARCHAR2(100) NOT NULL,
	PRIMARY KEY (PROGRAM_ID),
	UNIQUE (INSTITUTION, CONCENTRATION, DEGREE)
);

CREATE TABLE EDUCATION (
	USER_ID NUMBER,
	PROGRAM_ID INTEGER,
	PROGRAM_YEAR INTEGER NOT NULL,
	PRIMARY KEY (USER_ID, PROGRAM_ID),
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
	FOREIGN KEY (PROGRAM_ID) REFERENCES PROGRAMS(PROGRAM_ID)
);


CREATE TABLE USER_EVENTS(
	EVENT_ID NUMBER,
	EVENT_CREATOR_ID NUMBER NOT NULL,
	EVENT_NAME VARCHAR2(100),
	EVENT_TAGLINE VARCHAR2(100),
	EVENT_DESCRIPTION VARCHAR2(100),
	EVENT_HOST VARCHAR2(100),
	EVENT_TYPE VARCHAR2(100),
	EVENT_SUBTYPE VARCHAR2(100),
	EVENT_ADDRESS VARCHAR2(2000),
	EVENT_CITY_ID INTEGER NOT NULL,
	EVENT_START TIMESTAMP,
	EVENT_END TIMESTAMP,
	PRIMARY KEY (EVENT_ID),
	FOREIGN KEY (EVENT_CREATOR_ID) REFERENCES USERS(USER_ID),
	FOREIGN KEY (EVENT_CITY_ID) REFERENCES CITIES(CITY_ID)
);

CREATE TABLE PARTICIPANTS(
	EVENT_ID NUMBER,
	USER_ID NUMBER,
	CONFIRMATION VARCHAR2(100) NOT NULL,
	PRIMARY KEY (USER_ID, EVENT_ID),
	FOREIGN KEY (EVENT_ID) REFERENCES USER_EVENTS(EVENT_ID),
	FOREIGN KEY (USER_ID) REFERENCES USERS(USER_ID),
	CONSTRAINT CHK_CONFIRMATION CHECK ( CONFIRMATION IN ('ATTENDING', 'UNSURE', 'DECLINED','NOT-REPLIED') )
);


CREATE TABLE MESSAGE 
(
	message_id NUMBER,
	sender_id NUMBER,
	receiver_id NUMBER,
	message_content VARCHAR2(2000),
	sent_time TIMESTAMP,
	PRIMARY KEY(message_id),
	FOREIGN KEY(sender_id) REFERENCES Users(user_id),
	FOREIGN KEY(receiver_id) REFERENCES Users(user_id)
);


CREATE TABLE ALBUMS(
	album_id NUMBER,
	album_owner_id NUMBER NOT NULL,
	album_name VARCHAR2(100) NOT NULL,
	album_created TIMESTAMP NOT NULL,
	album_modified TIMESTAMP, 
	album_link VARCHAR2(2000) NOT NULL,
	album_visibility VARCHAR2(100) NOT NULL,
	cover_photo_id NUMBER NOT NULL,
	PRIMARY KEY (album_id),
	FOREIGN KEY (album_owner_id) REFERENCES Users(user_id),
	-- are we sure the visibility string are actually like that?
	CONSTRAINT CHK_ALBUM_VISIBILITY CHECK ( album_visibility IN ('EVERYONE', 'FRIENDS', 'FRIENDS_OF_FRIENDS', 'MYSELF', 'CUSTOM') )
);

CREATE TABLE PHOTOS
(
	photo_id NUMBER,
	album_id NUMBER NOT NULL,
	photo_caption VARCHAR2(2000),
	photo_created_time TIMESTAMP NOT NULL, 
	photo_modified_time TIMESTAMP, 
	photo_link VARCHAR2(2000) NOT NULL,
	PRIMARY KEY(photo_id),
	FOREIGN KEY(album_id) REFERENCES Albums INITIALLY DEFERRED DEFERRABLE --constraint should satisfy: 1) each photo owned by exactly one album (also see primary key) 2) each album must have at least one photo
);


CREATE TABLE TAGS(
	tag_photo_id NUMBER,
	tag_subject_id NUMBER,
	tag_created TIMESTAMP NOT NULL,
	tag_x NUMBER NOT NULL,
	tag_y NUMBER NOT NULL,
	PRIMARY KEY(tag_photo_id, tag_subject_id),
	FOREIGN KEY(tag_photo_id) REFERENCES Photos(photo_id),
	FOREIGN KEY(tag_subject_id) REFERENCES Users(user_id)
);


--alter statement is for circular dependency between albums and photos tables 
ALTER TABLE Albums 
ADD CONSTRAINT COVER_PHOTO_CONSTRAINT
FOREIGN KEY(cover_photo_id) REFERENCES Photos(photo_id) 
INITIALLY DEFERRED DEFERRABLE;

CREATE SEQUENCE seq1
	START WITH 1
	INCREMENT BY 1;

CREATE TRIGGER add_city_id
	BEFORE INSERT ON CITIES
		FOR EACH ROW
			BEGIN
				SELECT seq1.NEXTVAL INTO :NEW.CITY_ID FROM DUAL;
			END;
/

CREATE SEQUENCE seq2
	START WITH 1
	INCREMENT BY 1;

CREATE TRIGGER add_program_id
	BEFORE INSERT ON PROGRAMS
		FOR EACH ROW
			BEGIN
				SELECT seq2.NEXTVAL INTO :NEW.PROGRAM_ID FROM DUAL;
			END;
/

CREATE TRIGGER friendship_uniqueness
	BEFORE INSERT ON FRIENDS
		FOR EACH ROW
			DECLARE temp number;
			BEGIN
			    IF :NEW.USER1_ID < :NEW.USER2_ID 
			    THEN 
				    temp := :NEW.USER1_ID;
				    :NEW.USER1_ID := :NEW.USER2_ID;
				    :NEW.USER2_ID := temp;
			    END IF;
			END;
/
