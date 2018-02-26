# Schema Design
Sassytwitter

## Schema Type
### [Relational Schema](#relation)
### [Nonrelational Schema](#nonrelation)


## <a name="relation"></a> Relational Schema
* [ActiveRecord Notation](#relation_ar)
* [Table Definition](#relation_table)
* [Diagram](#relation_diagram)

### <a name="relation_ar"></a> ActiveRecord Notation
table **Users**<br>
&nbsp;&nbsp;&nbsp;&nbsp;primary key user_id: integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;email: text<br>
&nbsp;&nbsp;&nbsp;&nbsp;password: text<br>
&nbsp;&nbsp;&nbsp;&nbsp;apitoken: text<br>

table **Follows**<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key user_id: integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key follower_id: integer<br>

table **Tweets**<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key tweet_id: integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;text: text<br>
&nbsp;&nbsp;&nbsp;&nbsp;creation_time: time<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key author_id: integer<br>

table **Profiles**<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key user_id: integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;bio: text<br>
&nbsp;&nbsp;&nbsp;&nbsp;dob: date<br>
&nbsp;&nbsp;&nbsp;&nbsp;date_joined: date<br>
&nbsp;&nbsp;&nbsp;&nbsp;location: text<br>

table **Mentions**<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key tweet_id: integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key user_id: integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;author_id: integer<br>

table **Hashtags**<br>
&nbsp;&nbsp;&nbsp;&nbsp;primary key hashtag_name: text<br>
&nbsp;&nbsp;&nbsp;&nbsp;foreign key tweet_id: text<br>

**Users**<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many Users through Follows<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many Tweets<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_one Profiles<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many Mentions<br>

**Profiles**<br>
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Users<br>

**Tweets**<br>
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Users<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many Mentions<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many Hashtags<br>

**Mentions**<br>
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Tweets<br>
&nbsp;&nbsp;&nbsp;&nbsp;belongs_to Users<br>

**Hashtags**<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many Tweets<br>

### <a name="relation_table"></a> Tables
**Users**

|     | Key Type | Data Type | Description | Rquired |
| --- | -------- | --------- | ----------- | ------- |
| **user_id** | primary key | `integer` | The identifier of user | Yes |
| **email** | | `text` | Email of user | Yes |
| **password** | | `text` | Password of user | Yes |
| **apitoken** | | `text` | For distinguishing API calls that need a logged in user vs. those that are public. Those that are public would not require the user's apitoken. | default: nil |

<br>

**Follows**

|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**user_id**|foreign key to **Users**|`integer`|The id of user| Yes |
|**follower_id**|foreign key to **Users**|`integer`|The user who follows **<user_id>** user| Yes |

<br>

**Tweets**

|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**tweet_id**|primary key|`integer`|The unique id of tweet|Yes|
|**text**||`text`|The text content of tweet|Yes default: ""|
|**creation_time**||`time`|The time when this tweet created|Yes|
|**author_id**|foreign key to **Users**|`integer`|Id of the user who created this tweet|Yes|

<br>

**Profiles**

|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**user_id**|foreign key to **Users**|`integer`|The user's id|Yes|
|**bio**||`text`|The bio of user|No|
|**dob**||`date`|The date of birth of user|No|
|**date_joined**||`date`|The date this user created|Yes|
|**location**||`text`|The location where this user is|No|

<br>

**Mentions**

|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**tweet_id**|foreign key to **Tweets**|`integer`| The id of tweet|Yes|
|**user_id**|foreign key to **Users**|`integer`|The user is mentioned in this tweet|Yes|
|**author_id**||`integer`|The user who wrote this tweet|TBD|

<br>

**Hashtags**

|   |Key Type|Data Type|Description|Rquired|
|---|--------|---------|-----------|-------|
|**hashtag_name**|primary key|`text`|The content of this hashtag|Yes|
|**tweet_id**|foreign key to **Tweets**|`integer`|The id of this tweet|Yes|

### <a name="relation_diagram"></a> Schema Diagram

![alt relational schema](https://github.com/amgoncalves/sassy-twitter/blob/master/doc/design/shema/Relation_diagram.png)

## <a name="nonrelation"></a> Nonrelational Schema
* [MongoID Notation](#nonrelation_mapper)
* [Diagram](#nonrelation_diagram)

### <a name="nonrelation_mapper"></a> MongoID Notation
**User**
&nbsp;&nbsp;&nbsp;&nbsp;field :user_id, type: Integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :email, type: String<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :password, type: String<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :api_token, type: String<br>

&nbsp;&nbsp;&nbsp;&nbsp;embeds_one :profile<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many :followers<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_many :followings<br>

**Profile**
&nbsp;&nbsp;&nbsp;&nbsp;field :bio, type: String<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :dob, type: Date<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :date_joined, type: Date<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :location, type: String<br>

&nbsp;&nbsp;&nbsp;&nbsp;embedded_in :user<br>

**Tweet**
&nbsp;&nbsp;&nbsp;&nbsp;field :tweet_id, type: Integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :content, type: String<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :time_created, type: Timestamp<br>
&nbsp;&nbsp;&nbsp;&nbsp;field :author_id, type: Integer<br>

&nbsp;&nbsp;&nbsp;&nbsp;has_and_belongs_to_many :mentions<br>
&nbsp;&nbsp;&nbsp;&nbsp;has_and_belongs_to_many :hashtags<br>

**Mention**
&nbsp;&nbsp;&nbsp;&nbsp;field: user_id, type: Integer<br>

&nbsp;&nbsp;&nbsp;&nbsp;has_and_belongs_to_many :tweets<br>

**Hashtag**
&nbsp;&nbsp;&nbsp;&nbsp;field: hashtag_id, type: Integer<br>
&nbsp;&nbsp;&nbsp;&nbsp;field: hashtag_name, type: String<br>

&nbsp;&nbsp;&nbsp;&nbsp;has_and_belongs_to_many :tweets<br>

**Follower**
&nbsp;&nbsp;&nbsp;&nbsp;field: follower_id, type: Integer<br>

&nbsp;&nbsp;&nbsp;&nbsp;belongs_to :user<br>

**Following**
&nbsp;&nbsp;&nbsp;&nbsp;field: following_id, type: Integer<br>

&nbsp;&nbsp;&nbsp;&nbsp;belongs_to :user<br>


### <a name="nonrelation_diagram"></a> Diagram
