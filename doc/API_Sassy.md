NanoTwitter  (Sassy)
===========
`NanoTwitter (nT)` is a baby version of Twitter designed as a platform for experimentation with scaling issues.You can find out the code at [https://github.com/amgoncalves/sassy-twitter.git](https://github.com/amgoncalves/sassy-twitter.git). 

**Team:**
Sassy: Si Chen, Alyssa Goncalves, and Shuai Yu

**Version:** 0.1

You can import the yaml file in doc/design/API to see the swagger version by [ swagger editor](http://swagger.io)

## Service Funtions
### /
---
##### ***GET***
**Summary:** Index for unlogged in user

**Description:**  

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [Tweet](#tweet) ] |

### /:apitoken
---
##### ***GET***
**Summary:** Index for logged in user

**Description:**  

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [Tweet](#tweet) ] |

### /login
---
##### ***POST***
**Summary:** Process login for user

**Description:**  

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| email | path | email of user | Yes | string |
| password | path | password of user | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 202 | Succefully Logged In | [User](#user) |

### /logout
---
##### ***POST***
**Summary:** Process logout for user

**Description:**  

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | path | id of user | Yes | string (ObjectId) |

**Responses**

| Code | Description |
| ---- | ----------- |
| 202 | Succefully Logged Out |

### /signup
---
##### ***POST***
**Summary:** Process signup for user

**Description:**  

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| email | path | email of user | Yes | string |
| password | path | password of user | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 202 | Succefully Logged Out | [  ] |

### /users
---
##### ***GET***
**Summary:** Find all users

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [User](#user) ] |

### /follow
---
##### ***POST***
**Summary:** Construct the follow relationship between user and targted user

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| targeted_id | path | uesr id of who is followed | Yes | string |
| user_id | path | user id of current user | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [User](#user) |

## Profile
### /profile/edit
---
##### ***GET***
**Summary:** Profile edit page

**Description:**  

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [Profile](#profile) |

### /profile/edit/submit
---
##### ***POST***
**Summary:** Update an existing profile

**Description:** 

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| profile | body | Profile object that needs to be updated to the store | Yes | [Profile](#profile) |

**Responses**

| Code | Description |
| ---- | ----------- |
| 400 | Invalid ID supplied |
| 404 | Profile not found |
| 405 | Validation exception |

## User
### /user/:target_id
---
##### ***GET***
**Summary:** Finds user by id

**Description:** 

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| targeted_id | query | User id to filter by | Yes | string (ObejctId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [User](#user) |

### /user/new_tweets
---
##### ***GET***
**Summary:** List of 50 newest tweets of users followed by this user

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | query | user to filter by | Yes | string (ObjectId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [Tweet](#tweet) ] |

### /user/followings
---
##### ***GET***
**Summary:** Find followings of user

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | query | ID of user to find the followings | Yes | string (ObjectId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [User](#user) ] |

### /user/followeds
---
##### ***GET***
**Summary:** Find followeds of user

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | query | ID of user to find the followeds | Yes | string (ObjectId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [User](#user) ] |

### /user/posted
---
##### ***GET***
**Summary:** Find posted tweets of user

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | query | ID of user to find the posted tweets | Yes | string (ObjectId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [Tweet](#tweet) ] |

## Tweet
### /tweet/new
---
##### ***POST***
**Summary:** Create a new tweet

**Description:**  

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | path | id of user | Yes | string |
| content | path | content of tweet | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 202 | Succefully Created Tweet | [Tweet](#tweet) |

### /tweet/:tweet_id
---
##### ***GET***
**Summary:** Finds tweet by id

**Description:** 

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tweet_id | query | Tweet id to filter by | Yes | string (ObejctId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [Tweet](#tweet) |

### /tweet/like
---
##### ***POST***
**Summary:** Construct like relationship betweetn tweet and user

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | path | id of user | Yes | string |
| tweet_id | path | id of tweet | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 202 | Succefully Created Tweet |  |

### /tweet/retweet
---
##### ***POST***
**Summary:** Create a retweet for another tweet

**Description:**  

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | path | id of user | Yes | string |
| tweet_id | path | id of original tweet | Yes | string |
| content | path | content of tweet | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 202 | Succefully Created ReTweet | [Tweet](#tweet) |

## Reply
### /reply
---
##### ***POST***
**Summary:** Create a reply for another tweet

**Description:**  

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| tweet_id | path | id of user | Yes | string |
| content | path | content of tweet | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 202 | Succefully Created Reply | [Reply](#reply) |

## Search
### /search/:hashtag_id
---
##### ***GET***
**Summary:** Search tweets by hashtag

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| hashtag_id | query | Hashtag id to filter by | Yes | string (ObejctId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [Tweet](#tweet) ] |

### /search/:user_id
---
##### ***GET***
**Summary:** Search user by user id

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| user_id | query | User id to filter by | Yes | string (ObejctId) |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [User](#user) |

### /search/:keyword
---
##### ***GET***
**Summary:** Search tweets by keyword

**Parameters**

| Name | Located in | Description | Required | Schema |
| ---- | ---------- | ----------- | -------- | ---- |
| keyword | query | keyword to filter by | Yes | string |

**Responses**

| Code | Description | Schema |
| ---- | ----------- | ------ |
| 200 | successful operation | [ [Tweet](#tweet) ] |

### Models
---

### User  

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| _id | string (ObjectId) |  | No |
| handle | string |  | No |
| email | string |  | Yes |
| password | string (BCrypt) |  | Yes |
| apitoken | string |  | No |
| profiles | [ [Profile](#profile) ] |  | No |
| followeds | [ integer ] |  | No |
| followings | [ integer ] |  | No |
| tweets | [ integer ] |  | No |
| likedtweets | [ integer ] |  | No |

### Profile  

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| name | string |  | No |
| bio | string |  | No |
| dob | dateTime |  | No |
| date_joined | dateTime |  | No |
| location | string |  | No |

### Tweet  

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| _id | string (ObjectId) |  | No |
| content | string |  | No |
| time_created | dateTime |  | No |
| author_id | string (ObjectId) |  | No |
| original_tweet_id | string (ObjectId) |  | No |
| likedby | [ string (ObjectId) ] |  | No |
| replys | [ string (ObjectId) ] |  | No |

### Reply  

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| _id | string (ObjectId) |  | No |
| tweet_id | string (ObjectId) |  | No |
| content | string |  | No |
| time_created | dateTime |  | No |
| author_id | string (ObjectId) |  | No |

### Hashtag  

| Name | Type | Description | Required |
| ---- | ---- | ----------- | -------- |
| _id | string (ObjectId) |  | No |
| hashtag_name | string |  | No |
| tweets | [ string (ObjectId) ] |  | No |
