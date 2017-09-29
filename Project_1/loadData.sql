SET CONSTRAINT COVER_PHOTO_CONSTRAINT DEFERRED;
INSERT INTO USERS (USER_ID, FIRST_NAME, LAST_NAME, YEAR_OF_BIRTH, MONTH_OF_BIRTH, DAY_OF_BIRTH, GENDER)
SELECT DISTINCT USER_ID, FIRST_NAME, LAST_NAME, YEAR_OF_BIRTH, MONTH_OF_BIRTH, DAY_OF_BIRTH, GENDER
FROM jsoren.PUBLIC_USER_INFORMATION;

-- How do we prevent loading (b,a) if we already have (a,b)?
INSERT INTO FRIENDS(USER1_ID, USER2_ID)
SELECT USER1_ID, USER2_ID
FROM jsoren.PUBLIC_ARE_FRIENDS;


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


-- 
INSERT INTO CITIES(CITY_NAME, STATE_NAME, COUNTRY_NAME)
SELECT DISTINCT u.CURRENT_CITY, u.CURRENT_STATE, u.CURRENT_COUNTRY FROM (
		SELECT CURRENT_CITY, CURRENT_STATE, CURRENT_COUNTRY 
		FROM jsoren.PUBLIC_USER_INFORMATION 
	UNION 
		SELECT HOMETOWN_CITY, HOMETOWN_STATE, HOMETOWN_COUNTRY 
		FROM jsoren.PUBLIC_USER_INFORMATION) u;


-- test code
-- SELECT TOP 100 CURRENT_CITY, CURRENT_STATE, CURRENT_COUNTRY FROM PUBLIC_USER_INFORMATION WHERE ROWNUM <= 20;
-- 	UNION 
-- SELECT TOP 100 HOMETOWN_CITY, HOMETOWN_STATE, HOMETOWN_COUNTRY FROM PUBLIC_USER_INFORMATION WHERE ROWNUM <= 20


INSERT INTO USER_CURRENT_CITY(USER_ID, CURRENT_CITY_ID)
SELECT DISTINCT u.USER_ID, c.CITY_ID
FROM jsoren.PUBLIC_USER_INFORMATION u, CITIES c
WHERE u.CURRENT_CITY = c.CITY_NAME AND
u.CURRENT_STATE = c.STATE_NAME AND
u.CURRENT_COUNTRY = c.COUNTRY_NAME;

INSERT INTO USER_HOMETOWN_CITY (USER_ID, HOMETOWN_CITY_ID)
SELECT DISTINCT u.USER_ID, c.CITY_ID
FROM jsoren.PUBLIC_USER_INFORMATION u, CITIES c
WHERE u.HOMETOWN_CITY = c.CITY_NAME AND
u.HOMETOWN_STATE = c.STATE_NAME AND
u.HOMETOWN_COUNTRY = c.COUNTRY_NAME;


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

-- 
INSERT INTO PROGRAMS (INSTITUTION, CONCENTRATION, DEGREE)
SELECT DISTINCT INSTITUTION_NAME, PROGRAM_CONCENTRATION, PROGRAM_DEGREE
FROM jsoren.PUBLIC_USER_INFORMATION;

INSERT INTO EDUCATION (USER_ID, PROGRAM_ID, PROGRAM_YEAR)
SELECT u.USER_ID, p.PROGRAM_ID, u.PROGRAM_YEAR
FROM jsoren.PUBLIC_USER_INFORMATION u, PROGRAMS p
WHERE u.INSTITUTION_NAME = p.INSTITUTION AND 
u.PROGRAM_CONCENTRATION = p.CONCENTRATION AND 
u.PROGRAM_DEGREE = p.DEGREE;

SET AUTOCOMMIT OFF;

--LOAD PHOTOS
INSERT INTO Photos(
	photo_id, 
	album_id, 
	photo_caption, 
	photo_modified, 
	photo_link) 
SELECT DISTINCT t1.PHOTO_ID, 
	t1.ALBUM_ID, 
	t1.PHOTO_CAPTION, 
	t1.PHOTO_MODIFIED_TIME, 
	t1.PHOTO_LINK
FROM jsoren.PUBLIC_PHOTO_INFORMATION t1

--LOAD ALBUMS
INSERT INTO Albums(
	album_id, 
	album_owner_id, 
	album_name, 
	album_created, 
	album_modified, 
	album_link, 
	album_visibility, 
	cover_photo_id)
SELECT DISTINCT
	t1.ALBUM_ID, 
	t1.OWNER_ID, 
	t1.ALBUM_NAME, 
	t1.ALBUM_CREATED_TIME, 
	t1.ALBUM_MODIFIED_TIME, 
	t1.ALBUM_LINK, 
	t1.ALBUM_VISIBILITY, 
	t1.COVER_PHOTO_ID
FROM jsoren.PUBLIC_PHOTO_INFORMATION t1
WHERE t1.ALBUM_VISIBILITY in ('EVERYONE', 'FRIENDS', 'FRIENDS OF FRIENDS', 'MYSELF', 'CUSTOM')

--SET CONSTRAINT COVER_PHOTO_CONSTRAINT IMMEDIATE;
COMMIT;
SET AUTOCOMMIT ON;

--LOAD TAGS
INSERT INTO Tags(
	tag_photo_id, 
	tag_subject_id, 
	tag_created, 
	tag_x, 
	tag_y)
SELECT DISTINCT
	t1.PHOTO_ID, 
	t1.TAG_SUBJECT_ID, 
	t1.TAG_CREATED_TIME, 
	t1.TAG_X_COORDINATE, 
	t1.TAG_Y_COORDINATE
FROM jsoren.PUBLIC_TAG_INFORMATION t1, USERS t2, PHOTOS t3
WHERE t1.TAG_SUBJECT_ID = t2.USER_ID
AND t1.PHOTO_ID IS NOT NULL
AND t1.PHOTO_ID = t3.photo_id;

--LOAD EVENTS
INSERT INTO USER_EVENTS(
	EVENT_ID,
	EVENT_CREATOR_ID,
	EVENT_NAME,
	EVENT_TAGLINE,
	EVENT_DESCRIPTION,
	EVENT_HOST,
	EVENT_TYPE,
	EVENT_SUBTYPE,
	EVENT_ADDRESS,
	EVENT_CITY_ID,
	EVENT_START,
	EVENT_END)
SELECT 
	t1.EVENT_ID, 
	t1.EVENT_CREATOR_ID, 
	t1.EVENT_NAME,
	t1.EVENT_TAGLINE,
	t1.EVENT_DESCRIPTION,
	t1.EVENT_HOST,
	t1.EVENT_TYPE,
	t1.EVENT_SUBTYPE,
	t1.EVENT_ADDRESS,
	t2.CITY_ID,  
	t1.EVENT_START_TIME,
	t1.EVENT_END_TIME
FROM
	jsoren.PUBLIC_EVENT_INFORMATION t1, CITIES t2
WHERE t1.EVENT_CITY = t2.CITY_NAME
	AND t1.EVENT_STATE = t2.STATE_NAME
	AND t1.EVENT_COUNTRY = t2.COUNTRY_NAME;

