-- test VIEW_USER_INFORMATION
-- SELECT * FROM jsoren.PUBLIC_USER_INFORMATION MINUS SELECT * FROM VIEW_USER_INFORMATION;

-- SELECT * FROM VIEW_USER_INFORMATION  MINUS SELECT * FROM jsoren.PUBLIC_USER_INFORMATION;

-- SELECT * FROM VIEW_USER_INFORMATION  INTERSECT SELECT * FROM jsoren.PUBLIC_USER_INFORMATION;

-- test VIEW_ARE_FRIENDS
-- SELECT * FROM jsoren.PUBLIC_ARE_FRIENDS MINUS SELECT * FROM VIEW_ARE_FRIENDS;

-- SELECT * FROM VIEW_ARE_FRIENDS MINUS SELECT * FROM jsoren.PUBLIC_ARE_FRIENDS;

-- test PHOTOS
SELECT * FROM jsoren.PUBLIC_PHOTO_INFORMATION MINUS SELECT * FROM VIEW_PHOTO_INFORMATION; -- 1889

-- test EVENTS
SELECT * FROM jsoren.PUBLIC_EVENT_INFORMATION MINUS SELECT * FROM VIEW_EVENT_INFORMATION;

-- 90	   85		1687	Mountains	21-DEC-69 02.00.00.000000 PM 05-JUN-26 03.00.00.000000 AM link everyone

-- 90	   85		1687	Mountains	21-DEC-69 02.00.00.000000 PM 	05-JUN-26 03.00.00.000000 AM	link	EVERYONE
-- 1691	03-MAR-99 04.00.00.000000 PM 	link

-- 04-DEC-28 04.00.00.000000 PM --the photo created time is missing!!! 

-- test TAGS
SELECT * FROM VIEW_TAG_INFORMATION MINUS SELECT * FROM jsoren.PUBLIC_TAG_INFORMATION;

-- 663		589			18-MAR-89 11.00.00.000000 PM 		3	       85

-- select count(*) from(select FIRST_NAME from jsoren.PUBLIC_USER_INFORMATION minus select FIRST_NAME from VIEW_USER_INFORMATION);
-- select count(*) from(select LAST_NAME from jsoren.PUBLIC_USER_INFORMATION minus select LAST_NAME from VIEW_USER_INFORMATION);
-- select count(*) from(select YEAR_OF_BIRTH from jsoren.PUBLIC_USER_INFORMATION minus select YEAR_OF_BIRTH from VIEW_USER_INFORMATION);
-- select count(*) from(select MONTH_OF_BIRTH from jsoren.PUBLIC_USER_INFORMATION minus select MONTH_OF_BIRTH from VIEW_USER_INFORMATION);
-- select count(*) from(select PROGRAM_YEAR from jsoren.PUBLIC_USER_INFORMATION minus select PROGRAM_YEAR from VIEW_USER_INFORMATION);
-- select count(*) from(select PROGRAM_YEAR from jsoren.PUBLIC_USER_INFORMATION minus select PROGRAM_YEAR from VIEW_USER_INFORMATION);