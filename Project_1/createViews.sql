--CREATE PUBLIC PHOTO INFORMATION VIEW 
SELECT 
	t1.album_id, 
	t1.album_owner_id,
	t1.cover_photo_id,
	t1.album_name,
	t1.album_created,
	t1.album_modified,
	t1.album_link,
	t1.album_visibility,
	t2.photo_id,
	t2.photo_caption,
	t2.photo_created,
	t2.photo_modified,
	t2.photo_link
FROM Albums t1, Photos t2
WHERE t1.album_id = t2.album_id

--CREATE TAGS VIEW
SELECT 
	tag_photo_id,
	tag_subject_id,
	tag_created,
	tag_x_coordinate,
	tag_y_coordinate
FROM
	Tags

--CREATE PUBLIC EVENT INFORMATION VIEW 
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
	t2.EVENT_STATE,
	t2.EVENT_COUNTRY,
	t1.EVENT_START,
	t1.EVENT_END
FROM t2.Events, t2.CITIES
WHERE t1.EVENT_CITY_ID = t2.EVENT_CITY_ID