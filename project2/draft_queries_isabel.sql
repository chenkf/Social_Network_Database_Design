SELECT FIRST_NAME, COUNT(*)
FROM jiaqni.PUBLIC_USERS
GROUP BY FIRST_NAME

#1)
SELECT DISTINCT FIRST_NAME, 
CASE WHEN LENGTH(FIRST_NAME) = 9 THEN 'long' 
FROM jiaqni.PUBLIC_USERS
WHERE LENGTH(FIRST_NAME) = 9
OR LENGTH(FIRST_NAME) = 4



#2
SELECT USER_ID, FIRST_NAME, LAST_NAME FROM jiaqni.PUBLIC_USERS
WHERE USER_ID IN (SELECT DISTINCT USER_ID FROM jiaqni.PUBLIC_USERS MINUS
(SELECT DISTINCT user1_id FROM  jiaqni.PUBLIC_FRIENDS UNION SELECT DISTINCT user2_id FROM jiaqni.PUBLIC_FRIENDS))


#1) Find all combinations of users who are not friends with each other  
SELECT USER_ID FROM jiaqni.PUBLIC_FRIENDS JOIN(

CREATE VIEW NON_FRIENDS AS 
SELECT t1.USER_ID, t2.USER_ID 
FROM jiaqni.PUBLIC_USERS t1, jiaqni.PUBLIC_USERS t2 
WHERE t1.USER_ID <> t2.USER_ID
MINUS 
SELECT * FROM ALL_FRIENDS

CREATE VIEW ALL_FRIENDS AS
SELECT DISTINCT * FROM(
SELECT user1_id, user2_id FROM jiaqni.PUBLIC_FRIENDS
UNION
SELECT user2_id, user1_id FROM jiaqni.PUBLIC_FRIENDS
);

ON USER_ID = t1;


#6)
select f1.user1_id, f1.user2_id, f2.user1_id, f2.user2_id, u1.user1_id, u2.user2_id, u3.user1_id
from jiaqni.PUBLIC_FRIENDS f1, jiaqni.PUBLIC_FRIENDS f2, jiaqni.PUBLIC_FRIENDS u1, jiaqni.PUBLIC_FRIENDS u2, jiaqni.PUBLIC_FRIENDS u3
where (f1.user2_id = f2.user2_id and f1.user1_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user2_id = u3.user1_id) 
or (f1.user2_id = f2.user1_id and f1.user1_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user2_id = u3.user1_id) 
or (f1.user1_id = f2.user2_id and f1.user2_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user1_id = u3.user1_id)
or (f1.user1_id = f2.user1_id and f1.user2_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user1_id = u3.user1_id)

  

and not exists(
	select * from jiaqni.PUBLIC_FRIENDS nf
	where f1.user1_id)


-- select f1.user1_id, f1.user2_id, f2.user1_id, f2.user2_id, 
-- from jiaqni.PUBLIC_FRIENDS f1, jiaqni.PUBLIC_FRIENDS f2
-- where f1.user1_id = f2.user1_id
-- or f1.user1_id = f2.user2_id 
-- or f1.user2_id = f2.user2_id

select u1.user1_id, u2.user2_id, distinct u3.user
from jiaqni.PUBLIC_FRIENDS f1, jiaqni.PUBLIC_FRIENDS f2, jiaqni.PUBLIC_FRIENDS u1, jiaqni.PUBLIC_FRIENDS u2
where (f1.user2_id = f2.user1_id and f1.user1_id = u1.user1_id and f2.user2_id = u2.user2_id) 
or (f1.user2_id = f2.user2_id and f1.user1_id = u1.user1_id and f2.user1_id = u2.user2_id) 
or (f1.user1_id = f2.user2_id and f1.user2_id = u1.user1_id and f2.user1_id = u2.user2_id)
or (f1.user1_id = f2.user1_id and f1.user2_id = u1.user1_id and f2.user2_id = u2.user2_id)
and not exists (select * from jiaqni.PUBLIC_FRIENDS f3
				where f3.user1_id = u1.user1_id and f3.user2_id = u2.user2_id)
group by u1.user1_id, u2.user2_id 

--------------------
--------------------
CREATE VIEW ALL_FRIENDS AS
SELECT DISTINCT * FROM(
SELECT user1_id, user2_id FROM jiaqni.PUBLIC_FRIENDS
UNION
SELECT user2_id, user1_id FROM jiaqni.PUBLIC_FRIENDS
);

select a.user1_id, a.user2_id
from ALL_FRIENDS a, jiaqni.PUBLIC_FRIENDS

select t1.user1_id, t1.user2_id, n.FIRST_NAME, n.LAST_NAME, n2.FIRST_NAME, n2.LAST_NAME from (
	
	CREATE VIEW ALL_FRIEND_PAIRS AS 
	select f1.user1_id as user1_id, f1.user2_id as user2_id, f2.user1_id as user3_id, f2.user2_id as user4_id
	from jiaqni.PUBLIC_FRIENDS f1, jiaqni.PUBLIC_FRIENDS f2, jiaqni.PUBLIC_FRIENDS u1, jiaqni.PUBLIC_FRIENDS u2
	where (f1.user2_id = f2.user2_id and f1.user1_id = u1.user1_id and f2.user1_id = u2.user2_id) 
	or (f1.user2_id = f2.user1_id and f1.user1_id = u1.user1_id and f2.user2_id = u2.user2_id) 
	or (f1.user1_id = f2.user2_id and f1.user2_id = u1.user1_id and f2.user1_id = u2.user2_id)
	or (f1.user1_id = f2.user1_id and f1.user2_id = u1.user1_id and f2.user2_id = u2.user2_id)
	and not exists (select * from jiaqni.PUBLIC_FRIENDS f3
	 				where f3.user1_id = u1.user1_id and f3.user2_id = u2.user2_id)
	

	group by u1.user1_id, u2.user2_id
	order by cnt DESC, u1.user1_id ASC, u2.user2_id ASC) t1, jiaqni.PUBLIC_USERS n, jiaqni.PUBLIC_USERS n2
where t1.user1_id = n.USER_ID 
and t1.user2_id = n2.USER_ID
and rownum <=10;
--------------------
--------------------


select t1.user1_id, t1.user2_id, n.FIRST_NAME, n.LAST_NAME, n2.FIRST_NAME, n2.LAST_NAME from (
	select u1.user1_id, u2.user2_id, count(distinct u3.user1_id) as cnt
	from jiaqni.PUBLIC_FRIENDS f1, jiaqni.PUBLIC_FRIENDS f2, jiaqni.PUBLIC_FRIENDS u1, jiaqni.PUBLIC_FRIENDS u2, jiaqni.PUBLIC_FRIENDS u3
	where (f1.user2_id = f2.user2_id and f1.user1_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user2_id = u3.user1_id) 
	or (f1.user2_id = f2.user1_id and f1.user1_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user2_id = u3.user1_id) 
	or (f1.user1_id = f2.user2_id and f1.user2_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user1_id = u3.user1_id)
	or (f1.user1_id = f2.user1_id and f1.user2_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user1_id = u3.user1_id)
	-- and not exists (select * from jiaqni.PUBLIC_FRIENDS f3
	--  				where f3.user1_id = u1.user1_id and f3.user2_id = u2.user2_id)
	group by u1.user1_id, u2.user2_id
	order by cnt DESC, u1.user1_id ASC, u2.user2_id ASC) t1, jiaqni.PUBLIC_USERS n, jiaqni.PUBLIC_USERS n2
where t1.user1_id = n.USER_ID 
and t1.user2_id = n2.USER_ID
and rownum <=10;


-------------------
"select * from(
select u1.user1_id, u2.user2_id, count(distinct u3.user1_id) as cnt from " 
+ friendsTableName + " f1, " 
+friendsTableName + " f2, " 
+ friendsTableName + " u1, " 
+ friendsTableName + "u2, " 
+ friendsTableName + " u3 where (f1.user2_id = f2.user2_id and f1.user1_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user2_id = u3.user1_id) or (f1.user2_id = f2.user1_id and f1.user1_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user2_id = u3.user1_id) or (f1.user1_id = f2.user2_id and f1.user2_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user1_id = u3.user1_id) or (f1.user1_id = f2.user1_id and f1.user2_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user1_id = u3.user1_id)
and not exists (select * from " + jiaqni.PUBLIC_FRIENDS + " f3 where f3.user1_id = u1.user1_id and f3.user2_id = u2.user2_id) group by u1.user1_id, u2.user2_id order by cnt DESC, u1.user1_id ASC, u2.user2_id ASC) where rownum <=10"
-------------------

SELECT FIRST_NAME, cnt FROM(
	SELECT FIRST_NAME, cnt, RANK() OVER (ORDER BY cnt DESC) AS rank FROM(
		SELECT FIRST_NAME, COUNT(*) AS cnt
		FROM jiaqni.PUBLIC_USERS 
		GROUP BY FIRST_NAME 
		ORDER BY cnt DESC))
WHERE rank = 1

#FORMATTED:
SELECT FIRST_NAME, cnt FROM (SELECT FIRST_NAME, cnt, RANK() OVER (ORDER BY cnt DESC) AS rank FROM (SELECT FIRST_NAME, COUNT(*) AS cnt FROM 
	jiaqni.PUBLIC_USERS 
GROUP BY FIRST_NAME ORDER BY cnt DESC)) WHERE rank = 1



#7) Find the name of the state with the most events, as well as the number of events in that state. If there is a tie, return the names of all the tied states.
SELECT c.CITY_NAME, RANK() OVER (PARTITION BY c.CITY_NAME ORDER BY t1.cnt DESC) AS rank
FROM jiaqni.PU
SELECT e.EVENT_CITY_ID, COUNT(*) as cnt
FROM jiaqni.PUBLIC_USER_EVENTS e
GROUP BY e.EVENT_CITY_ID
ORDER BY cnt DESC) t1

SELECT STATE_NAME, cnt FROM (
	SELECT t1.STATE_NAME, t1.cnt, RANK() OVER (ORDER BY t1.cnt DESC) AS rank
	FROM (
		SELECT c.STATE_NAME, COUNT(*) AS cnt
		FROM jiaqni.PUBLIC_CITIES c, jiaqni.PUBLIC_USER_EVENTS e
		WHERE e.EVENT_CITY_ID = c.CITY_ID
		GROUP BY c.STATE_NAME
		ORDER BY COUNT(*) DESC) t1)
WHERE rank = 1; 


"SELECT STATE_NAME, cnt FROM (SELECT t1.STATE_NAME, t1.cnt, RANK() OVER (ORDER BY t1.cnt DESC) AS rank FROM (SELECT c.STATE_NAME, COUNT(*) AS cnt FROM " 
	+ cityTableName+ " c, " + eventTableName + 
                " e WHERE e.EVENT_CITY_ID = c.CITY_ID GROUP BY c.STATE_NAME ORDER BY COUNT(*) DESC) t1) WHERE rank = 1" 





SELECT c.EVENT_CITY_ID, c.cnt, RANK() OVER (PARTITION BY c.cnt ORDER BY c.cnt DESC) AS rank from(
SELECT e.EVENT_CITY_ID, COUNT(*) as cnt
FROM jiaqni.PUBLIC_USER_EVENTS e
GROUP BY e.EVENT_CITY_ID) c




-- // ***** Query 8 *****
-- // Given the ID of a user, find information about that
-- // user's oldest friend and youngest friend
-- //
-- // If two users have exactly the same age, meaning that they were born
-- // on the same day, then assume that the one with the larger user_id is older
-- //
uid = 489
CREATE VIEW ALL_FRIENDS AS
SELECT DISTINCT * FROM(
SELECT user1_id, user2_id FROM jiaqni.PUBLIC_FRIENDS
UNION SELECT user2_id, user1_id FROM jiaqni.PUBLIC_FRIENDS);

select * from(
select u.FIRST_NAME, u.LAST_NAME, u.YEAR_OF_BIRTH, u.MONTH_OF_BIRTH, u.DAY_OF_BIRTH 
from (select f.user2_id from ALL_FRIENDS f where f.user1_id = 215) t1, jiaqni.PUBLIC_USERS u 
where t1.user2_id = u.user_id
order by u.YEAR_OF_BIRTH desc, u.MONTH_OF_BIRTH desc, u.DAY_OF_BIRTH desc, u.user_id desc)
where rownum = 1;

select * from(
select u.FIRST_NAME, u.LAST_NAME, u.YEAR_OF_BIRTH, u.MONTH_OF_BIRTH, u.DAY_OF_BIRTH 
from (select f.user2_id from ALL_FRIENDS f where f.user1_id = 215) t1, jiaqni.PUBLIC_USERS u 
where t1.user2_id = u.user_id
order by u.YEAR_OF_BIRTH asc, u.MONTH_OF_BIRTH asc, u.DAY_OF_BIRTH asc, u.user_id desc)
where rownum = 1;

select user1_id 
from jiaqni.PUBLIC_FRIENDS  

