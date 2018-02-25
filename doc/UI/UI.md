# UI Design

## List of UIs
*all routes starts with **/api/v1***

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

## Details
### <a name="u01"></a> UnloggedIn Homepage
* List of the most recent 50 tweets from any user, each with link to tweeter's page
* [Login](#u02) link
* Move the cursor over user's name can review the [profile](#u05) of the user
* Click the tweet can review the [tweet](#u06) page

![not logged in user home page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/NonLoggedInHP.png)

### <a name="u02"></a> Log in page
* An input field enable user to log in by email and password
* Email address and password must not be empty
* Show warning message for not existing email address
* Show warning message for wrong password
* A link to [Sign up](#u03)
* A link to verify user information and transfer to [logged in homepage](#u04) for successful log in

![log in page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/LogIn.png)

### <a name="u03"></a> Sign up page
* An input field to register new account by inputting email and password
* Email address and password must not be empty
* Show warning message for existing email address
* Sign up link to create user and direct to [logged in homepage](#u04) for successful sign up

![sign up page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/Signup.png)

### <a name="u04"></a> LoggedIn Homepage
* List of most recent 50 tweets of users you follow
* A field for inputting new tweet contents and create it by clicking **Tweet**
* A mini profile of current logged in user which includes
    - the number of tweets of this user
    - a link to [list of users followed](#u09) by this user.
    - a link to [list of users following this user](#u08)
    - a link to this [user's page](#u07)
* A link to [Log Out](#u01)
* Search field and show the [tweet results](#u10) for inputting keyword
* A drop down menu in menu bar which can direct to [Home](#u04), [Profile](#u05), [MyPage](#u07), Setting
* When moved the cursor over user's name in twitter, there appear the [profile pop up window for this user](#u05)
* When click the tweet, direct to [tweet detail page](#u06)

![logged in home page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/LoggedInHP.png)

### <a name="u05"></a> Profile pop up page
![profile page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/Profile(pop).png)

### <a name="u06"></a> Tweet page
![tweet page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/Tweet(Unfollowing).png)

### <a name="u07"></a> User page
![user page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/User(Following).png)

### <a name="u08"></a> Followers list page
![followers list page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/Followers.png)

### <a name="u09"></a> Followings list page
![followings list page](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/Followings.png)

### <a name="u10"></a> Search Tweet result page
![tweet search result](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/TweetSearch(keyword).png)

### <a name="u11"></a> Search User result page
![user search result](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/UI/mockUIs/UserSearch(hashtag).png)







