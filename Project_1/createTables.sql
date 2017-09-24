CREATE TABLE Messages 
(
message_id INTEGER,
sender_id INTEGER,
receiver_id INTEGER,
message_content (VARCHAR2(2000)),
sent_time TIMESTAMP,
PRIMARY KEY(mid),
FOREIGN KEY(sender_id) REFERENCES Users(user_id),
FOREIGN KEY(receiver_id) REFERENCES Users(user_id)
);

CREATE TABLE Photos
(
photo_id INTEGER,
album_id INTEGER,
photo_caption (VARCHAR2(2000),
photo_created TIMESTAMP, 
photo_modified TIMESTAMP, 
photo_link (VARCHAR2(2000),
PRIMARY KEY(photo_id),
FOREIGN KEY(album_id) REFERENCES Albums NOT NULL, --constraint should satisfy: 1) each photo owned by exactly one album 2) each album must have at least one photo
);

CREATE TABLE Albums(
album_id INTEGER,
album_owner_id INTEGER,
album_name VARCHAR2(100),
album_created TIMESTAMP,
album_modified TIMESTAMP, 
album_link VARCHAR2(2000),
album_visibility VARCHAR2(100),
cover_photo_id INTEGER,
PRIMARY KEY(album_id),
FOREIGN KEY(album_owner_id) REFERENCES Users(user_id) NOT NULL,
CONSTRAINT CHK_ALBUM_VISIBILITY CHECK ( album_visibility in ('everyone', 'friends', 'friends of friends', 'myself', 'custom') );
);

CREATE TABLE Tags(
tag_photo_id INTEGER,
tag_subject_id INTEGER,
tag_created TIMESTAMP,
tag_x INTEGER,
tag_y INTEGER,
PRIMARY KEY(tag_photo_id, tag_subject_id),
FOREIGN KEY(tag_photo_id) REFERENCES Photos(photo_id),
FOREIGN KEY(tag_subject_id) REFERENCES Users(user_id)
)


--alter statement is for circular dependency between albums and photos tables 
ALTER TABLE Albums 
ADD CONSTRAINT COVER_PHOTO_CONSTRAINT
FOREIGN KEY(photo_id) NOT NULL REFERENCES Photos(photo_id) 
INITIALLY DEFERRED DEFERRABLE;
