# Schema Design

## ActiveRecord Noation
table Users    
    primary key user_id: integer    
    email: text    
    password: text    
    apitoken: text    

table Follows    
    foreign key user_id: integer    
    foreign key follower_id: integer    

table Tweets    
    foreign key tweet_id: integer    
    text: text    
    creation_time: time    
    foreign key author_id: integer    

table Profiles    
    foreign key user_id: integer    
    bio: text    
    dob: date    
    date_joined: date    
    location: text    

table Mentions    
    foreign key tweet_id: integer    
    foreign key user_id: integer    
    author_id: integer    

table Hashtags    
    primary key hashtag_name: text    
    foreign key tweet_id: text    

Users    
    has_many Users through Follows    
    has_many Tweets    
    has_one Profiles    
    has_many Mentions    

Profiles    
    belongs_to Users    

Tweets    
    belongs_to Users    
    has_many Mentions    
    has_many Hashtags    

Mentions    
    belongs_to Tweets    
    belongs_to Users    

Hashtags    
    has_many Tweets    
