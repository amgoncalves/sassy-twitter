## Schema Design

### ActiveRecord Noation
table **Users**
&nbsp;&nbsp;&nbsp;&nbsp;primary key user_id: integer
&nbsp;&nbsp;&nbsp;&nbsp;email: text
&nbsp;&nbsp;&nbsp;&nbsp;password: text
&nbsp;&nbsp;&nbsp;&nbsp;apitoken: text

table **Follows**
&nbsp;&nbsp;&nbsp;&nbsp;foreign key follower_id: integer
&nbsp;&nbsp;&nbsp;&nbsp;foreign key follower_id: integer

table **Tweets**
&nbsp;&nbsp;&nbsp;&nbsp;foreign key tweet_id: integer
&nbsp;&nbsp;&nbsp;&nbsp;text: text
&nbsp;&nbsp;&nbsp;&nbsp;creation_time: time
&nbsp;&nbsp;&nbsp;&nbsp;foreign key author_id: integer

table **Profiles**
&nbsp;&nbsp;&nbsp;&nbsp;foreign key user_id: integer
&nbsp;&nbsp;&nbsp;&nbsp;bio: text
&nbsp;&nbsp;&nbsp;&nbsp;dob: date
&nbsp;&nbsp;&nbsp;&nbsp;date_joined: date
&nbsp;&nbsp;&nbsp;&nbsp;location: text

table **Mentions**
&nbsp;&nbsp;&nbsp;&nbsp;foreign key tweet_id: integer
&nbsp;&nbsp;&nbsp;&nbsp;foreign key user_id: integer
&nbsp;&nbsp;&nbsp;&nbsp;author_id: integer

table **Hashtags**
&nbsp;&nbsp;&nbsp;&nbsp;primary key hashtag_name: text
&nbsp;&nbsp;&nbsp;&nbsp;foreign key tweet_id: text

**Users**
&nbsp;&nbsp;&nbsp;&nbsp;has_many Users through Follows
&nbsp;&nbsp;&nbsp;&nbsp;has_many Tweets
&nbsp;&nbsp;&nbsp;&nbsp;has_one Profiles
&nbsp;&nbsp;&nbsp;&nbsp;has_many Mentions

**Profiles**
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Users

**Tweets**
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Users
&nbsp;&nbsp;&nbsp;&nbsp;has_many Mentions
&nbsp;&nbsp;&nbsp;&nbsp;has_many Hashtags

**Mentions**
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Tweets
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Users

**Hashtags**
&nbsp;&nbsp;&nbsp;&nbsp;has_many Tweets

### Tables
**Users**
|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**user_id**|primary key|`integer`|The identifier of user| Yes |
|**email**||`text`|Email of user|Yes|
|**password**||`text`|Password of user|Yes|
|**apitoken**||`text`|For distinguishing API calls that need a logged in user vs. those that are public. Those that are public would not require the user's apitoken.|default: nil|

**Follows**
|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**follower_id**|foreign key to **Users**|`integer`|The user who is followed| Yes |
|**following_id**|foreign key to **Users**|`integer`|The user who follows **follower** user| Yes|

**Tweets**
|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**tweet_id**|primary key|`integer`|The unique id of tweet|Yes|
|**text**||`text`|The text content of tweet|Yes default: ""|
|**creation_time**||`time`|The time when this tweet created|Yes|
|**author_id**|foreign key to **Users**|`integer`|Id of the user who created this tweet|Yes|

**Profiles**
|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**user_id**|foreign key to **Users**|`integer`|The user's id|Yes|
|**bio**||`text`|The bio of user|No|
|**dob**||`date`|The date of birth of user|No|
|**date_joined**||`date`|The date this user created|Yes|
|**location**||`text`|The location where this user is|No|

**Mentions**
|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**tweet_id**|foreign key to **Tweets**|`integer`| The id of tweet|Yes|
|**user_id**|foreign key to **Users**|`integer`|The user is mentioned in this tweet|Yes|
|**author_id**||`integer`|The user who wrote this tweet|TBD|

**Hashtags**
|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**hashtag_name**|primary key|`text`|The content of this hashtag|Yes|
|**tweet_id**|foreign key to **Tweets**|`integer`|The id of this tweet|Yes|


