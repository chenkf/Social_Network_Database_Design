select distinct u1.user1_id, u2.user2_id, u3.user1_id
	from jiaqni.PUBLIC_FRIENDS f1, jiaqni.PUBLIC_FRIENDS f2, jiaqni.PUBLIC_FRIENDS u1, jiaqni.PUBLIC_FRIENDS u2, jiaqni.PUBLIC_FRIENDS u3
	where (f1.user2_id = f2.user2_id and f1.user1_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user2_id = u3.user1_id) 
	or (f1.user2_id = f2.user1_id and f1.user1_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user2_id = u3.user1_id) 
	or (f1.user1_id = f2.user2_id and f1.user2_id = u1.user1_id and f2.user1_id = u2.user2_id and f1.user1_id = u3.user1_id)
	or (f1.user1_id = f2.user1_id and f1.user2_id = u1.user1_id and f2.user2_id = u2.user2_id and f1.user1_id = u3.user1_id)
	and not exists (select * from jiaqni.PUBLIC_FRIENDS f3
	 				where f3.user1_id = u1.user1_id and f3.user2_id = u2.user2_id)



CREATE VIEW ALL_FRIENDS AS
SELECT DISTINCT * FROM(
SELECT user1_id, user2_id FROM jiaqni.PUBLIC_FRIENDS
UNION
SELECT user2_id, user1_id FROM jiaqni.PUBLIC_FRIENDS
);


create view mutual_friends as
select f.user2_id as user1_id, jf.user2_id as user2_id, jf.user1_id as common_friend 
from ALL_FRIENDS jf, ALL_FRIENDS f
where jf.user1_id = f.user1_id
and jf.user2_id != f.user2_id
and jf.user2_id < f.user2_id 
and not exists(select * from ALL_FRIENDS jf2 
				where jf.user1_id = f.user1_id and jf.user2_id = f.user2_id);

select * from(
select user1_id, user2_id, count(distinct common_friend) as cnt
from mutual_friends
group by user1_id, user2_id
order by cnt desc)
where rownum <= 10;


select f.*, u.first_name as friend1_first_name, u.last_name as friend1_last_name, u2.first_name as friend2_first_name, u2.last_name as friend1_last_name, u3.first_name as mutFriend_first_name, u3.last_name as mutFriend_last_name
from mutual_friends f, jiaqni.PUBLIC_USERS u, jiaqni.PUBLIC_USERS u2, jiaqni.PUBLIC_USERS u3
where f.user1_id = 359 and f.user2_id = 122
and f.user1_id = u.user_id 
and f.user2_id = u2.user_id 
and f.common_friend = u3.user_id;

#6)
select t1.*, u.first_name as f1_first_name, u.last_name as f1_last_name, u2.first_name as f2_first_name, u2.last_name as f_last_name, u3.first_name as cf_first_name, u3.last_name as cf_last_name from (select f.* from mutual_friends f, top_n n where f.user1_id = n.user1_id and f.user2_id = n.user2_id) t1, jiaqni.PUBLIC_USERS u, jiaqni.PUBLIC_USERS u2, jiaqni.PUBLIC_USERS u3 where t1.user1_id = 359 and t1.user2_id = 122 
and t1.user1_id = u.user_id and t1.user2_id = u2.user_id and t1.common_friend = u3.user_id

select * from mutual_friends
---------
create view working as select f.*, u.first_name as f1_first_name, u.last_name as f1_last_name, u2.first_name as f2_first_name, u2.last_name as f_last_name, u3.first_name as cf_first_name, u3.last_name as cf_last_name from mutual_friends f,  
jiaqni.PUBLIC_USERS u, jiaqni.PUBLIC_USERS u2, jiaqni.PUBLIC_USERS u3 where f.user1_id = 359 and f.user2_id = 122 and f.user1_id = u.user_id and f.user2_id = u2.user_id and f.common_friend = u3.user_id

"create view mutual_friends as select f.user2_id as user1_id, jf.user2_id as user2_id, jf.user1_id as common_friend from " + 
"ALL_FRIENDS jf, ALL_FRIENDS f where jf.user1_id = f.user1_id and jf.user2_id != f.user2_id and jf.user2_id < f.user2_id " + 
"and not exists(select * from ALL_FRIENDS jf2 where jf.user1_id = f.user1_id and jf.user2_id = f.user2_id)";


"select * from(select user1_id, user2_id, count(distinct common_friend) as cnt " +
"from mutual_friends group by user1_id, user2_id order by cnt desc) where rownum <= 10";

"select t1.*, u.first_name as f1_first_name, u.last_name as f1_last_name, " + 
"u2.first_name as f2_first_name, u2.last_name as f_last_name, u3.first_name as cf_first_name, " +
"u3.last_name as cf_last_name from (select f.* from mutual_friends f, top_n n " +
"where f.user1_id = n.user1_id and f.user2_id = n.user2_id) t1, " + 
userTableName + " u, " + userTableName + " u2, " + userTableName +
"where t1.user1_id = u.user_id and t1.user2_id = u2.user_id and t1.common_friend = u3.user_id"

"select f.*, u.first_name as friend1_first_name, u.last_name as friend1_last_name, u2.first_name as friend2_first_name, u2.last_name as friend1_last_name, u3.first_name as mutFriend_first_name, u3.last_name as mutFriend_last_name
from mutual_friends f, "+ userTableName " u, " + userTableName " u2, " + userTableName +
" u3 where f.user1_id = " + 359 " and f.user2_id = " + 122 " and f.user1_id = u.user_id and f.user2_id = u2.user_id and f.common_friend = u3.user_id";

create view not_friends as select n.user1_id, n.user2_id, u1.first_name as f1_first_name, u1.last_name 
	as f1_last_name, u2.first_name as f2_first_name, u2.last_name as f2_last_name from top_n n,
jiaqni.PUBLIC_USERS u1, jiaqni.PUBLIC_USERS u2 where n.user1_id = u1.user_id and n.user2_id = u2.user_id

select t1.*, u.first_name as f1_first_name, u.last_name as f1_last_name, 
u2.first_name as f2_first_name, u2.last_name as f_last_name, u3.first_name as cf_first_name, 
u3.last_name as cf_last_name from (select f.* from mutual_friends f, top_n n 
where f.user1_id = n.user1_id and f.user2_id = n.user2_id) t1, 
jiaqni.PUBLIC_USERS u, jiaqni.PUBLIC_USERS u2, jiaqni.PUBLIC_USERS u3
where t1.user1_id = u.user_id and t1.user2_id = u2.user_id and t1.common_friend = u3.user_id



create view test as select t1.*, u.first_name as f1_first_name, u.last_name as f1_last_name, u2.first_name as f2_first_name, u2.last_name as f_last_name, u3.first_name as cf_first_name, u3.last_name as cf_last_name from (select f.* from mutual_friends f, top_n n where f.user1_id = n.user1_id and f.user2_id = n.user2_id) t1,  
jiaqni.PUBLIC_USERS u, jiaqni.PUBLIC_USERS u2, jiaqni.PUBLIC_USERS u3 where t1.user1_id = 359 and t1.user2_id = 122 and t1.user1_id = u.user_id and t1.user2_id = u2.user_id and t1.common_friend = u3.user_id
