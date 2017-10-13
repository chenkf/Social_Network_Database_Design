package project2;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class MyFakebookOracle extends FakebookOracle {

    static String prefix = "jiaqni.";

    // You must use the following variable as the JDBC connection
    Connection oracleConnection = null;

    // You must refer to the following variables for the corresponding tables in your database
    String cityTableName = null;
    String userTableName = null;
    String friendsTableName = null;
    String currentCityTableName = null;
    String hometownCityTableName = null;
    String programTableName = null;
    String educationTableName = null;
    String eventTableName = null;
    String participantTableName = null;
    String albumTableName = null;
    String photoTableName = null;
    String coverPhotoTableName = null;
    String tagTableName = null;


    // DO NOT modify this constructor
    public MyFakebookOracle(String dataType, Connection c) {
        super();
        oracleConnection = c;
        // You will use the following tables in your Java code
        cityTableName = prefix + dataType + "_CITIES";
        userTableName = prefix + dataType + "_USERS";
        friendsTableName = prefix + dataType + "_FRIENDS";
        currentCityTableName = prefix + dataType + "_USER_CURRENT_CITY";
        hometownCityTableName = prefix + dataType + "_USER_HOMETOWN_CITY";
        programTableName = prefix + dataType + "_PROGRAMS";
        educationTableName = prefix + dataType + "_EDUCATION";
        eventTableName = prefix + dataType + "_USER_EVENTS";
        albumTableName = prefix + dataType + "_ALBUMS";
        photoTableName = prefix + dataType + "_PHOTOS";
        tagTableName = prefix + dataType + "_TAGS";
    }


    @Override
    // ***** Query 0 *****
    // This query is given to your for free;
    // You can use it as an example to help you write your own code
    //
    public void findMonthOfBirthInfo() {

        // Scrollable result set allows us to read forward (using next())
        // and also backward.
        // This is needed here to support the user of isFirst() and isLast() methods,
        // but in many cases you will not need it.
        // To create a "normal" (unscrollable) statement, you would simply call
        // Statement stmt = oracleConnection.createStatement();
        //
        try (Statement stmt =
                     oracleConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                             ResultSet.CONCUR_READ_ONLY)) {

            // For each month, find the number of users born that month
            // Sort them in descending order of count
            ResultSet rst = stmt.executeQuery("select count(*), month_of_birth from " +
                    userTableName +
                    " where month_of_birth is not null group by month_of_birth order by 1 desc");

            this.monthOfMostUsers = 0;
            this.monthOfLeastUsers = 0;
            this.totalUsersWithMonthOfBirth = 0;

            // Get the month with most users, and the month with least users.
            // (Notice that this only considers months for which the number of users is > 0)
            // Also, count how many total users have listed month of birth (i.e., month_of_birth not null)
            //
            while (rst.next()) {
                int count = rst.getInt(1);
                int month = rst.getInt(2);
                if (rst.isFirst())
                    this.monthOfMostUsers = month;
                if (rst.isLast())
                    this.monthOfLeastUsers = month;
                this.totalUsersWithMonthOfBirth += count;
            }

            // Get the names of users born in the "most" month
            rst = stmt.executeQuery("select user_id, first_name, last_name from " +
                    userTableName + " where month_of_birth=" + this.monthOfMostUsers);
            while (rst.next()) {
                Long uid = rst.getLong(1);
                String firstName = rst.getString(2);
                String lastName = rst.getString(3);
                this.usersInMonthOfMost.add(new UserInfo(uid, firstName, lastName));
            }

            // Get the names of users born in the "least" month
            rst = stmt.executeQuery("select first_name, last_name, user_id from " +
                    userTableName + " where month_of_birth=" + this.monthOfLeastUsers);
            while (rst.next()) {
                String firstName = rst.getString(1);
                String lastName = rst.getString(2);
                Long uid = rst.getLong(3);
                this.usersInMonthOfLeast.add(new UserInfo(uid, firstName, lastName));
            }

            // Close statement and result set
            rst.close();
            stmt.close();
        } catch (SQLException err) {
            System.err.println(err.getMessage());
        }
    }

    @Override
    // ***** Query 1 *****
    // Find information about users' names:
    // (1) The longest first name (if there is a tie, include all in result)
    // (2) The shortest first name (if there is a tie, include all in result)
    // (3) The most common first name, and the number of times it appears (if there
    //      is a tie, include all in result)
    //
    public void findNameInfo() { // Query1
        // Find the following information from your database and store the information as shown
        this.longestFirstNames.add("JohnJacobJingleheimerSchmidt");
        this.shortestFirstNames.add("Al");
        this.shortestFirstNames.add("Jo");
        this.shortestFirstNames.add("Bo");
        this.mostCommonFirstNames.add("John");
        this.mostCommonFirstNames.add("Jane");
        this.mostCommonFirstNamesCount = 10;
    }

    @Override
    // ***** Query 2 *****
    // Find the user(s) who have no friends in the network
    //
    // Be careful on this query!
    // Remember that if two users are friends, the friends table
    // only contains the pair of user ids once, subject to
    // the constraint that user1_id < user2_id
    //
    public void lonelyUsers() {
        // Find the following information from your database and store the information as shown
        this.lonelyUsers.add(new UserInfo(10L, "Billy", "SmellsFunny"));
        this.lonelyUsers.add(new UserInfo(11L, "Jenny", "BadBreath"));
    }

    @Override
    // ***** Query 3 *****
    // Find the users who do not live in their hometowns
    // (I.e., current_city != hometown_city)
    //
    public void liveAwayFromHome() throws SQLException {

        try (Statement stmt =
                     oracleConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                             ResultSet.CONCUR_READ_ONLY)) {
            // For each month, find the number of users born that month
            // Sort them in descending order of count
            ResultSet rst = stmt.executeQuery("SELECT u.USER_ID, u.FIRST_NAME, u.LAST_NAME FROM " +
                    userTableName + " u, " + currentCityTableName + " ct, " + hometownCityTableName +
                    " ht " +  
                    "WHERE u.USER_ID = ct.USER_ID AND " +
                    "ct.USER_ID = ht.USER_ID AND " +
                    "ht.HOMETOWN_CITY_ID <> ct.CURRENT_CITY_ID " +
                    "ORDER BY u.USER_ID");

            while (rst.next()) { 
                Long uid = rst.getLong(1);
                String firstName = rst.getString(2);
                String lastName = rst.getString(3);
                this.liveAwayFromHome.add(new UserInfo(uid, firstName, lastName));
            }

            // Close statement and result set
            rst.close();
            stmt.close();
        } catch (SQLException err) {
            System.err.println(err.getMessage());
        } 

        
    }

    @Override
    // **** Query 4 ****
    // Find the top-n photos based on the number of tagged users
    // If there are ties, choose the photo with the smaller numeric PhotoID first
    //
    public void findPhotosWithMostTags(int n) {

        try (Statement stmt =
             oracleConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                     ResultSet.CONCUR_READ_ONLY)) {

            // For each month, find the number of users born that month
            // Sort them in descending order of count
            ResultSet rst = stmt.executeQuery("SELECT x.TAG_PHOTO_ID, p.ALBUM_ID, a.ALBUM_NAME, p.PHOTO_CAPTION, p.PHOTO_LINK " +
            "FROM (SELECT t.TAG_PHOTO_ID, COUNT(TAG_SUBJECT_ID) AS NUM_TAGGED " +
            "FROM " + tagTableName + " t " +
            "GROUP BY t.TAG_PHOTO_ID " +
            "ORDER BY NUM_TAGGED DESC, t.TAG_PHOTO_ID) x, " + photoTableName + " p, " + albumTableName + " a " +
            "WHERE x.TAG_PHOTO_ID = p.PHOTO_ID " + 
            "AND p.ALBUM_ID = a.ALBUM_ID " +
            "AND ROWNUM <= " + n );

            int rsCount = 0;
            while (rst.next()) {
                String photoId = rst.getString(1);
                String albumId = rst.getString(2);
                String albumName = rst.getString(3);
                String photoCaption = rst.getString(4);
                String photoLink = rst.getString(5);
                PhotoInfo p = new PhotoInfo(photoId, albumId, albumName, photoCaption, photoLink);
                TaggedPhotoInfo tp = new TaggedPhotoInfo(p);

                try (Statement stmt2 =
                             oracleConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     ResultSet.CONCUR_READ_ONLY)) {

                    ResultSet rst2 = stmt2.executeQuery("SELECT DISTINCT u.USER_ID, u.FIRST_NAME, u.LAST_NAME " +
                    "FROM " + tagTableName + " t, " + userTableName + " u " +
                    "WHERE t.TAG_SUBJECT_ID = u.USER_ID " +
                    "AND t.TAG_PHOTO_ID = " + photoId);   

                    while (rst2.next()) {
                        Long uid = rst2.getLong(1);
                        String firstname = rst2.getString(2);
                        String lastname = rst2.getString(3);
                        tp.addTaggedUser(new UserInfo(uid, firstname, lastname));
                    }  

                    this.photosWithMostTags.add(tp);

                    // Close statement and result set
                    rst2.close();
                    stmt2.close();
                } catch (SQLException err) {
                    System.err.println(err.getMessage());
                } 
            }
            // Close statement and result set
            rst.close();
            stmt.close();
        } catch (SQLException err) {
            System.err.println(err.getMessage());
        } 
    }

    @Override
    // **** Query 5 ****
    // Find suggested "match pairs" of users, using the following criteria:
    // (1) Both users should be of the same gender
    // (2) They should be tagged together in at least one photo (They do not have to be friends of the same person)
    // (3) Their age difference is <= yearDiff (just compare the years of birth for this)
    // (4) They are not friends with one another
    //
    // You should return up to n "match pairs"
    // If there are more than n match pairs, you should break ties as follows:
    // (i) First choose the pairs with the largest number of shared photos
    // (ii) If there are still ties, choose the pair with the smaller user1_id
    // (iii) If there are still ties, choose the pair with the smaller user2_id
    //
    public void matchMaker(int n, int yearDiff) {


        try (Statement stmt =
                     oracleConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                             ResultSet.CONCUR_READ_ONLY)) {
            // approach 1
            ResultSet rst = stmt.executeQuery("SELECT x.USER1_ID, x.USER1_FIRST_NAME, x.USER1_LAST_NAME, x.USER1_YEAR_OF_BIRTH, x.USER2_ID, x.USER2_FIRST_NAME, x.USER2_LAST_NAME, x.USER2_YEAR_OF_BIRTH, COUNT(*) NUM_SHARED_PHOTOS " +
                "FROM (SELECT DISTINCT u1.USER_ID USER1_ID, u1.FIRST_NAME USER1_FIRST_NAME, u1.LAST_NAME USER1_LAST_NAME, u1.YEAR_OF_BIRTH USER1_YEAR_OF_BIRTH, u2.USER_ID USER2_ID, u2.FIRST_NAME USER2_FIRST_NAME, u2.LAST_NAME USER2_LAST_NAME, u2.YEAR_OF_BIRTH USER2_YEAR_OF_BIRTH " +
                    "FROM " + friendsTableName + " f, " + userTableName + " u1, " + userTableName + " u2, " + tagTableName + " t1, " + tagTableName + " t2 " +
                    "WHERE u1.USER_ID = t1.TAG_SUBJECT_ID " +
                    "AND u2.USER_ID = t2.TAG_SUBJECT_ID " +
                    "AND t1.TAG_PHOTO_ID = t2.TAG_PHOTO_ID " +
                    "AND u1.GENDER = u2.GENDER " +
                    "AND ABS(u1.YEAR_OF_BIRTH - u2.YEAR_OF_BIRTH) <= " + yearDiff + " " + 
                    // -- There are 4 cases
                    "AND u1.USER_ID < u2.USER_ID " +
                    "AND ((f.USER1_ID = u1.USER_ID AND f.USER2_ID != u2.USER_ID) OR (f.USER2_ID = u2.USER_ID AND f.USER1_ID != u1.USER_ID)) ) x, " + tagTableName + " t3, " + tagTableName + " t4 " + 
                "WHERE x.USER1_ID = t3.TAG_SUBJECT_ID " +
                "AND x.USER2_ID = t4.TAG_SUBJECT_ID " +
                "AND t3.TAG_PHOTO_ID = t4.TAG_PHOTO_ID " +
                "AND ROWNUM <= " + n + " " + 
                "GROUP BY x.USER1_ID, x.USER1_FIRST_NAME, x.USER1_LAST_NAME, x.USER1_YEAR_OF_BIRTH, x.USER2_ID, x.USER2_FIRST_NAME, x.USER2_LAST_NAME, x.USER2_YEAR_OF_BIRTH " +
                "ORDER BY NUM_SHARED_PHOTOS DESC, USER1_ID, USER2_ID");

            // approach 2 
            // ResultSet rst = stmt.executeQuery("SELECT DISTINCT u1.USER_ID USER1_ID, u1.FIRST_NAME USER1_FIRST_NAME, u1.LAST_NAME USER1_LAST_NAME, u1.YEAR_OF_BIRTH USER1_YEAR_OF_BIRTH, u2.USER_ID USER2_ID, u2.FIRST_NAME USER2_FIRST_NAME, u2.LAST_NAME USER2_LAST_NAME, u2.YEAR_OF_BIRTH USER2_YEAR_OF_BIRTH, COUNT(DISTINCT t1.TAG_SUBJECT_ID) NUM_SHARED_PHOTOS " +
            //     "FROM " + friendsTableName + " f, " + userTableName + " u1, " + userTableName + " u2, " + tagTableName + " t1, " + tagTableName + " t2 " +
            //     "WHERE u1.USER_ID = t1.TAG_SUBJECT_ID " +
            //     "AND u2.USER_ID = t2.TAG_SUBJECT_ID " +
            //     "AND t1.TAG_PHOTO_ID = t2.TAG_PHOTO_ID " +
            //     "AND u1.GENDER = u2.GENDER " +
            //     "AND ABS(u1.YEAR_OF_BIRTH - u2.YEAR_OF_BIRTH) <= " + yearDiff + " " +
            //     // -- There are 4 cases
            //     "AND u1.USER_ID < u2.USER_ID " +
            //     "AND ((f.USER1_ID = u1.USER_ID AND f.USER2_ID != u2.USER_ID) OR (f.USER2_ID = u2.USER_ID AND f.USER1_ID != u1.USER_ID)) " +
            //     "AND ROWNUM <= " + n + " " +
            //     "GROUP BY u1.USER_ID, u1.FIRST_NAME, u1.LAST_NAME, u1.YEAR_OF_BIRTH, u2.USER_ID, u2.FIRST_NAME, u2.LAST_NAME, u2.YEAR_OF_BIRTH " +
            //     "ORDER BY NUM_SHARED_PHOTOS DESC, USER1_ID, USER2_ID");



            while (rst.next()) { 
                Long u1UserId = rst.getLong(1);
                String u1FirstName = rst.getString(2);
                String u1LastName = rst.getString(3);
                int u1Year = rst.getInt(4);
                Long u2UserId = rst.getLong(5);
                String u2FirstName = rst.getString(6);
                String u2LastName = rst.getString(7);
                int u2Year = rst.getInt(8);
                MatchPair mp = new MatchPair(u1UserId, u1FirstName, u1LastName,
                        u1Year, u2UserId, u2FirstName, u2LastName, u2Year);

                try (Statement stmt2 =
                             oracleConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                                     ResultSet.CONCUR_READ_ONLY)) {

                    ResultSet rst2 = stmt2.executeQuery("SELECT DISTINCT p.PHOTO_ID, p.ALBUM_ID, a.ALBUM_NAME, p.PHOTO_CAPTION, p.PHOTO_LINK " +
                        "FROM " + tagTableName + " t1, " + tagTableName + " t2, " + photoTableName + " p, " + albumTableName + " a " +
                        "WHERE t1.TAG_SUBJECT_ID = " + u1UserId + " " + 
                        "AND t2.TAG_SUBJECT_ID = " + u2UserId + " " + 
                        "AND t1.TAG_PHOTO_ID = t2.TAG_PHOTO_ID " +
                        "AND t1.TAG_PHOTO_ID = p.PHOTO_ID " +
                        "AND p.ALBUM_ID = a.ALBUM_ID");
                    
                    while (rst2.next()) {
                        String sharedPhotoId = rst2.getString(1);
                        String sharedPhotoAlbumId = rst2.getString(2);
                        String sharedPhotoAlbumName = rst2.getString(3);
                        String sharedPhotoCaption = rst2.getString(4);
                        String sharedPhotoLink = rst2.getString(5);
                        mp.addSharedPhoto(new PhotoInfo(sharedPhotoId, sharedPhotoAlbumId,
                                sharedPhotoAlbumName, sharedPhotoCaption, sharedPhotoLink));
                    }  

                    this.bestMatches.add(mp);
                    // Close statement and result set
                    rst2.close();
                    stmt2.close();
                } catch (SQLException err) {
                    System.err.println(err.getMessage());
                } 
            }


            // Close statement and result set
            rst.close();
            stmt.close();
        } catch (SQLException err) {
            System.err.println(err.getMessage());
        } 


    }

    // **** Query 6 ****
    // Suggest users based on mutual friends
    //
    // Find the top n pairs of users in the database who have the most
    // common friends, but are not friends themselves.
    //
    // Your output will consist of a set of pairs (user1_id, user2_id)
    // No pair should appear in the result twice; you should always order the pairs so that
    // user1_id < user2_id
    //
    // If there are ties, you should give priority to the pair with the smaller user1_id.
    // If there are still ties, give priority to the pair with the smaller user2_id.
    //
    @Override
    public void suggestFriendsByMutualFriends(int n) {
        Long user1_id = 123L;
        String user1FirstName = "User1FirstName";
        String user1LastName = "User1LastName";
        Long user2_id = 456L;
        String user2FirstName = "User2FirstName";
        String user2LastName = "User2LastName";
        UsersPair p = new UsersPair(user1_id, user1FirstName, user1LastName, user2_id, user2FirstName, user2LastName);

        p.addSharedFriend(567L, "sharedFriend1FirstName", "sharedFriend1LastName");
        p.addSharedFriend(678L, "sharedFriend2FirstName", "sharedFriend2LastName");
        p.addSharedFriend(789L, "sharedFriend3FirstName", "sharedFriend3LastName");
        this.suggestedUsersPairs.add(p);

    }

    @Override
    // ***** Query 7 *****
    //
    // Find the name of the state with the most events, as well as the number of
    // events in that state.  If there is a tie, return the names of all of the (tied) states.
    //
    public void findEventStates() {
        this.eventCount = 12;
        this.popularStateNames.add("Michigan");
        this.popularStateNames.add("California");
    }

    //@Override
    // ***** Query 8 *****
    // Given the ID of a user, find information about that
    // user's oldest friend and youngest friend
    //
    // If two users have exactly the same age, meaning that they were born
    // on the same day, then assume that the one with the larger user_id is older
    //
    public void findAgeInfo(Long user_id) {
        this.oldestFriend = new UserInfo(1L, "Oliver", "Oldham");
        this.youngestFriend = new UserInfo(25L, "Yolanda", "Young");
    }

    @Override
    //	 ***** Query 9 *****
    //
    // Find pairs of potential siblings.
    //
    // A pair of users are potential siblings if they have the same last name and hometown, if they are friends, and
    // if they are less than 10 years apart in age.  Pairs of siblings are returned with the lower user_id user first
    // on the line.  They are ordered based on the first user_id and in the event of a tie, the second user_id.
    //
    //
    public void findPotentialSiblings() {

        try (Statement stmt =
             oracleConnection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
                     ResultSet.CONCUR_READ_ONLY)) {
        // String cityTableName = null;
        // String userTableName = null;
        // String friendsTableName = null;
        // String currentCityTableName = null;
        // String hometownCityTableName = null;
        // String programTableName = null;
        // String educationTableName = null;
        // String eventTableName = null;
        // String participantTableName = null;
        // String albumTableName = null;
        // String photoTableName = null;
        // String coverPhotoTableName = null;
        // String tagTableName = null;
            ResultSet rst = stmt.executeQuery("SELECT f.USER1_ID, u1.FIRST_NAME, u1.LAST_NAME, f.USER2_ID, u2.FIRST_NAME, u2.LAST_NAME " +
                "FROM " + friendsTableName + " f, " + userTableName + " u1, " + userTableName + " u2, " + hometownCityTableName + " ht1, " + hometownCityTableName + " ht2 " +
                "WHERE f.USER1_ID = u1.USER_ID " +
                "AND f.USER2_ID = u2.USER_ID " +
                "AND u1.USER_ID = ht1.USER_ID " +
                "AND u2.USER_ID = ht2.USER_ID " +
                "AND u1.USER_ID < u2.USER_ID " +
                "AND u1.LAST_NAME = u2.LAST_NAME " +
                "AND ht1.HOMETOWN_CITY_ID = ht2.HOMETOWN_CITY_ID " +
                "AND ABS(u1.YEAR_OF_BIRTH - u2.YEAR_OF_BIRTH) < 10 " +
                "ORDER BY f.USER1_ID, f.USER2_ID");

            while (rst.next()) { 
                Long user1_id = rst.getLong(1);
                String user1FirstName = rst.getString(2);
                String user1LastName = rst.getString(3);
                Long user2_id = rst.getLong(4);
                String user2FirstName = rst.getString(5);
                String user2LastName = rst.getString(6);
                SiblingInfo s = new SiblingInfo(user1_id, user1FirstName, user1LastName, user2_id, user2FirstName, user2LastName);
                this.siblings.add(s);           
            }

            // Close statement and result set
            rst.close();
            stmt.close();
        } catch (SQLException err) {
            System.err.println(err.getMessage());
        } 
    }

}
