-- Test query 3: 756 rows selected.
SELECT u.USER_ID, FIRST_NAME, LAST_NAME FROM
jiaqni.PUBLIC_USERS u, jiaqni.PUBLIC_USER_CURRENT_CITY ct, jiaqni.PUBLIC_USER_HOMETOWN_CITY ht
WHERE u.USER_ID = ct.USER_ID AND
ct.USER_ID = ht.USER_ID AND 
HOMETOWN_CITY_ID <> CURRENT_CITY_ID 
ORDER BY USER_ID;

-- java -Xmx64M -cp "project2/ojdbc6.jar:" project2/TestFakebookOracle

-- java -Xmx64M -cp "project2/ojdbc6.jar:" project2/TestFakebookOracleFull

-- Test query 4:
SELECT x.TAG_PHOTO_ID, x.NUM_TAGGED
FROM (SELECT t.TAG_PHOTO_ID, COUNT(TAG_SUBJECT_ID) AS NUM_TAGGED
		FROM jiaqni.PUBLIC_TAGS t
		GROUP BY t.TAG_PHOTO_ID
		ORDER BY NUM_TAGGED DESC, t.TAG_PHOTO_ID) x
WHERE ROWNUM <= 5;