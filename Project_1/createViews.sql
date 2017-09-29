--CREATE PUBLIC_USER_INFORMATION VIEW 
CREATE VIEW VIEW_USER_INFORMATION AS
SELECT
	u.USER_ID,
	u.FIRST_NAME,
	u.LAST_NAME,
	u.YEAR_OF_BIRTH,
	u.MONTH_OF_BIRTH,
	u.DAY_OF_BIRTH,
	u.GENDER,
	ct1.CITY_NAME AS CURRENT_CITY,
	ct1.STATE_NAME AS CURRENT_STATE,
	ct1.COUNTRY_NAME AS CURRENT_COUNTRY,
	ct2.CITY_NAME AS HOMETOWN_CITY,
	ct1.STATE_NAME AS HOMETOWN_STATE,
	ct1.COUNTRY_NAME AS HOMETOWN_COUNTRY,
	p.INSTITUTION AS INTITUTION_NAME,
	e.PROGRAM_YEAR,
	p.CONCENTRATION AS PROGRAM_CONCENTRATION,
	p.DEGREE AS PROGRAM_DEGREE
FROM USERS u 
JOIN USER_CURRENT_CITY c ON u.USER_ID = c.USER_ID
JOIN USER_HOMETOWN_CITY h ON u.USER_ID = h.USER_ID
JOIN CITIES ct1 ON c.CURRENT_CITY_ID = ct1.CITY_ID
JOIN CITIES ct2 ON h.HOMETOWN_CITY_ID = ct2.CITY_ID
JOIN EDUCATION e ON u.USER_ID = e.USER_ID
JOIN PROGRAMS p ON e.PROGRAM_ID = p.PROGRAM_ID;

CREATE VIEW VIEW_FRIENDS AS
SELECT
	u1.USER_ID AS USER1_ID,
	u2.USER_ID AS USER2_ID
FROM FRIENDS f
JOIN USERS u1 ON f.USER1_ID = u1.USER_ID
JOIN USERS u2 ON f.USER2_ID = u2.USER_ID;


--CREATE PUBLIC PHOTO INFORMATION VIEW 
CREATE VIEW VIEW_PHOTO_INFORMATION AS
SELECT 
	t1.album_id, 
	t1.album_owner_id,
	t1.cover_photo_id,
	t1.album_name,
	t1.album_created AS ALBUM_CREATED_TIME,
	t1.album_modified AS ALBUM_MODIFIED_TIME,
	t1.album_link,
	t1.album_visibility,
	t2.photo_id,
	t2.photo_caption,
	t2.photo_created AS PHOTO_CREATED_TIME,
	t2.photo_modified AS PHOTO_MODIFIED_TIME,
	t2.photo_link
FROM Albums t1, Photos t2
WHERE t1.album_id = t2.album_id;

--CREATE TAGS VIEW
CREATE VIEW VIEW_TAG_INFORMATION AS
SELECT 
	tag_photo_id,
	tag_subject_id,
	tag_created AS tag_created_time,
	tag_x AS tag_x_coordinate,
	tag_y AS tag_y_coordinate
FROM
	Tags;

--CREATE PUBLIC EVENT INFORMATION VIEW 
CREATE VIEW VIEW_EVENT_INFORMATION AS
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
	t1.EVENT_CITY_ID,
	t2.STATE_NAME,
	t2.COUNTRY_NAME,
	t1.EVENT_START AS EVENT_START_TIME,
	t1.EVENT_END AS EVENT_END_TIME
FROM Events t1, CITIES t2
WHERE t1.EVENT_CITY_ID = t2.city_id;