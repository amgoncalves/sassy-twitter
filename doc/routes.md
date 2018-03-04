## Routes Design

### Routes Reference Index
* [/](#r01)
* [/login](#r02)
* [/logout](#r03)
* [/signup](#r04)
* [/edit_profile](#r05)
* [/edit_profile/submit](#05)
* [/user/:targeted_id](#r06)
* [/user/new_tweets](#r06)
* [/user/followings](#06)
* [/user/followeds](#06)
* [/users](#r07)
* [/follow](#r08)
* [/posted](#r09)
* [/tweet/:tweet_id](#r10)
* [/tweet/new](#r10)
* [/tweet/like](#r10)
* [/tweet/reply](#r10)
* [/reply](#r11)
* [/search](#r12)

### <a name="r01"></a> /
* GET / (Non-logged-in root page)
    - List of the most recent tweets from any user, each with link to tweeter’s page
    - Login link
    - Register link
* GET / (Logged-in root page)
    - List of most recent 50 tweets of users you follow
    - Ability to tweet
    - Mini-profile

### <a name="r02"></a> /login
* GET /login
get the login page
* POST /login
pass the email and password to login
    - email
    - password

### <a name="r03"></a> /logout
* POST /logout
Logout for particular user
    - user

### <a name="r04"></a> /signup
* GET /signup
Direct to signup page
* POST /signup/submit
Sign up a new user and empty profile in database
    - user

### <a name="r05"></a> /edit_profile
* GET /edit_profile
Direct to edit_profile page
* POST /edit_profile/submit
Edit the profile
    - profile
    - user

### <a name="r06"></a> /user
* GET /user/:targeted_id
    - targeted_id
    - user
```` 
 User <user_id>’s most recent 50 tweets
 User <user_id>’s mini-profile
 Button to follow that user (available only if logged in and not looking at self)
 Link to list of users followed by this user. Link text is a count
 Link to list of newest tweets of users followed by this user
 Link to list of users following this user. Link text is a count 
````

* GET /user/new_tweets
List of 50 newest tweets of users followed by this user
    - user


* POST /user/followings
List of users who are following this user
    - targeted_id

* POST /user/followeds
List of users who are following this user
    - targeted_id

### <a name="r07"></a> /users
* GET /users
    - user
Get all the users in database

### <a name="r08"></a> /follow
* POST /follow
    - targeted_id
    - user
Construct the follow relationship between user and targted user

### <a name="r09"></a> /posted
* GET /posted
    - user
Get the posted tweet of users

### <a name="r10"></a> /tweet
* POST /tweet/new
    - tweet
    - user
Create new tweet
* GET /tweet/:tweet_id
    - tweet_id
Display a specific tweet
* POST /tweet/like
    - tweet_id
    - user
Record the user likes this tweet
* POST /tweet/retweet
    - retweet
Create a new tweet which retweet another tweet

### <a name="r11"></a> /reply
* POST /reply
    - reply
    - tweet_id
Create a reply to a tweet

### <a name="r12"></a> /search
* Display search interface to search tweets with certain words
* [TBD] which terms would be included for matching

