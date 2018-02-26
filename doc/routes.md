## Routes Design

### /
* Non-logged-in root page
    - List of the most recent tweets from any user, each with link to tweeter’s page
    - Login link
    - Register link
* Logged-in root page
    - List of most recent 50 tweets of users you follow
    - Ability to tweet
    - Mini-profile

### /users/<user_id>/
* User <user_id>’s most recent 50 tweets
* User <user_id>’s mini-profile
* Button to follow that user (available only if logged in and not looking at self)
* Link to list of users followed by this user. Link text is a count
* Link to list of newest tweets of users followed by this user
* Link to list of users following this user. Link text is a count

### /users/<user_id>/followers
* List of users who are following this user

### /users/<user_id>/followings
* List of users this user is following

### /users/<user_id>/new_tweets
* List of newest tweets of users followed by this user

### /users/register
* Display the user registration page

### /login
* Display user login prompt, and check for correct password

### /logout
* Logout

### /verify
* Verify if the user who is trying to log in is an existing user in database

### /search
* Display search interface to search tweets with certain words
* [TBD] which terms would be included for matching

### /tweets/<tweet_id>
* Display a specific tweet



