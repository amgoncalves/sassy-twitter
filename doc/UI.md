# UI Design

## List of UIs
*all routes starts with **/api/v1***
*all routes atarts with **/api/v1/{apitoken}** for logged in user*

|ID|page name|description|URI|
| --- | --- | --- | --- |
| [U01](#u01) | UnloggedIn Homepage | The homepage displayed for not logged in users | / |
| [U02](#u02) | LogIn | User log in | /login |
| [U03](#u03) | SignUp | Register new user page | / register|
| [U04](#u04) | LoggedIn Homepage | The homepage displayed for logged in users | /{apitoken}/ |
| [U05](#u05) | Profile | The pop up window with user profile information | /users/{user_id}/profile |
| [U06](#u06) | Tweet | The page for particular tweet| /tweets/{tweet_id} |
| [U07](#u07) | User | The page for particular user | /users/{user_id} |
| [U08](#u08) | Followers | The page displaying all followers of current user | /users/{user_id}/followers |
| [U09](#u09) | Followings | The page displaying all followings of current user | /users/{user_id}/followings |
| [U10](#u10) | Search Tweet Result | The page displaying all search result tweets | /tweets/search |
| [U11](#u11) | Search User Result | The page displaying all search result users | /users/search |
| [U12](#u12) | User Homepage | The page displaying the recent tweets from the users followed by current user | /users/{user_id}/recents |

## Details
### <a name="u01"></a> UnloggedIn Homepage
* List of the most recent 50 tweets from any user, each with link to tweeter's page
* [Login](#u02) link
* Move the cursor over user's name can review the [profile](#u05) of the user
* Click the tweet can review the [tweet](#u06) page

![not logged in user home page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/NonLoggedInHP.png)

### <a name="u02"></a> Log in page
* An input field enable user to log in by email and password
* Email address and password must not be empty
* Show warning message for not existing email address
* Show warning message for wrong password
* A link to [Sign up](#u03)
* A link to verify user information and transfer to [logged in homepage](#u04) for successful log in

![log in page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/LogIn.png)

### <a name="u03"></a> Sign up page
* An input field to register new account by inputting email and password
* Email address and password must not be empty
* Show warning message for existing email address
* Sign up link to create user and direct to [logged in homepage](#u04) for successful sign up

![sign up page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/Signup.png)

### <a name="u04"></a> LoggedIn Homepage
* List of most recent 50 tweets of users you follow
* A field for inputting new tweet contents and create it by clicking **Tweet**
* A mini profile of current logged in user which includes
    - the number of tweets of this user
    - a link to [list of users followed](#u09) by this user.
    - a link to [list of users following this user](#u08)
    - a link to this [user's page](#u07) by clicking user's name
* A link to [Log Out](#u01)
* Search field and show the [tweet results](#u10) for inputting keyword
* A drop down menu in menu bar which can direct to [Home](#u04), [Profile](#u05), [MyPage](#u07), Setting
* When moved the cursor over user's name in twitter, there appear the [profile pop up window for this user](#u05). Move the cursor away from the user's name, the profile pop up window will disappear.
* When click the tweet, direct to [tweet detail page](#u06)

![logged in home page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/LoggedInHP.png)

### <a name="u05"></a> Profile pop up page
* Show profile of user
* A link to [user page](#u07) by clicking user's name
* Change follow relationship by click button **Follow** when not following, **Unfollow** to release following relationship
* a link to [list of users followed](#u09) by this user by clicking the count of followings.
* a link to [list of users following this user](#u08) by clicking the count of followers.

![profile page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/Profile(pop).png)

### <a name="u06"></a> Tweet page
* Show the tweet detail and all replies of this tweet
* The **#hashtag** link will direct to the [tweets serach result](#u10) with the topic word in hashtag
* The **@mentioned** link will direct to the [page of the user](#u07) mentioned
* Change follow relationship by click button **Follow** when not following, **Unfollow** to release following relationship
* Create a reply tweet by inputting tweet contents and clicking **Tweet** button
* Each reply tweet has a link to corresponding [tweet page](#u06)

![tweet page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/Tweet(Unfollowing).png)

### <a name="u07"></a> User page
* User's most recent 50 tweets
* User's mini profile
* Button to change the following relationship with this user. (Available only if logged in and not looking at self.)
* Button to edit profile. (Available only if logged in and looking at self.)
* Link to [list of users followed](#u09) by this user by clicking following
* Link to [list of users following thi user](#08) by clicking followers

![user page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/User(Following).png)

### <a name="u08"></a> Followers list page
* A list of followers' mini profiles
* Each profile block contains a link to corresponding [user's page](#u07)
* Change follow relationship by click button **Follow** when not following, **Unfollow** to release following relationship

![followers list page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/Followers.png)

### <a name="u09"></a> Followings list page
* A list of mini profiles of users who are following current user
* Each profile block contains a link to corresponding [user's page](#u07)
* Change follow relationship by click button **Follow** when not following, **Unfollow** to release following relationship

![followings list page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/Followings.png)

### <a name="u12"></a> User home pate
* A list of latest tweets from the users followed by current user

![user homepage](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/UserHP.png)

### <a name="u10"></a> Search Tweet result page
* A list of search result tweets which contains keyword or #hashtag and each contains a link to [tweet page](#u06)
* A link to search the [users](#u11) by current searching query

![tweet search result](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/TweetSearch(keyword).png)

### <a name="u11"></a> Search User result page
* A list of search result users which contains keyword or #hashtag and each contains a link to [user page](#u07)
* A link to search the [tweets](#u10) by current searching query

![user search result](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/UserSearch(hashtag).png)







