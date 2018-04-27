# Sassy Twitter [![Maintainability](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability)](https://codeclimate.com/github/codeclimate/codeclimate/maintainability)

* [View Portfolio](https://amgoncalves.github.io/sassy-twitter/)

* [View nanoTwitter](https://sassy-nanotwitter.herokuapp.com/)

* [View Development Logs for each version](https://github.com/amgoncalves/sassy-twitter/blob/master/README_VERSION.md)

* [Github Repo](https://github.com/amgoncalves/sassy-twitter)

* [Download repo](https://github.com/amgoncalves/sassy-twitter/archive/master.zip)


[Sassy nanoTwitter (nT)](https://sassy-nanotwitter.herokuapp.com/) is a minimal version of [Twitter](https://twitter.com/) built on [Sinatra](http://sinatrarb.com/) and deployed on [heroku](https://www.heroku.com/platform) cloud platform.  It can support the basic functions the same as Twitter that it allows user to register an account, build a profile, make a tweet and so on. Even this is a nano version of Twitter, but our main goal to scale this application based on data collected from load tests.

## Summary

Users who register for an account can broadcast short 400-character messages to the site-wide global timeline.  Each user has a unique username, called a handle, and a profile page with a log of their messages.  Users can follow other users to customize what messages they see in their personal feed.  Users have the ability to duplicate or "re-Tweet" any message onto their own timeline with an optional comment.  Prefixing a word with the pound or hashtag (#) symbol makes the term searchable by other users.  Search is available  for other users by their handle or search for tweets by keyword.  Optional cookies are used for persistent user sessions.

This application is optimized to scale with the load of user activity.  Caching, multi-threading, and a lightweight NoSQL database with in-memory data caching are employed to manage scalability problems.

nanoTwitter has a REST API that can be utilized with the [nanoTwitter Client Library](https://github.com/amgoncalves/nt-client) for client applications written in Ruby.

## Technology Description

We build full stack web application in Sinatra framework with high functional data storage system MongoDB and Redis, and frequent intergration of code using Codeship.
* nanoTwitter is written in [Sinatra](http://sinatrarb.com/) and runs on the [JRuby](http://jruby.org/) engine.  
* [Git](https://git-scm.com/) and [Github](https://github.com/amgoncalves/sassy-twitter) are used for version control.  
* The application is hosted on a [Heroku](https://www.heroku.com/) server at [https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/).  
* [Codeship](https://codeship.com/) is used to automate testing and deployment from Github.
* Application data is stored in a [MongoDB Community Server](https://www.mongodb.com/) database and uses the [mLab](https://mlab.com/) service on the production server.  The [Mongoid](https://docs.mongodb.com/mongoid/master/#ruby-mongoid-tutorial) ODM (Object-Document-Mapper) is used to convert between Sinatra-compatable abstract data types and MongoDB documents.  Data is cached in-memory using [Redis](https://redis.io/).
* The UI uses a combination of HTML and [embedded Ruby](https://ruby-doc.com/docs/ProgrammingRuby/html/web.html).  Elements are styled in CSS using [Bootstrap](https://getbootstrap.com/). [JQuery](https://jquery.com/) is used to provide additional functionality to certain UI elements.
* Load testing was accomplished by using [loader.io](https://loader.io/) to stress the application with thousands of concurrent connections. [New Relic](https://newrelic.com/) was used in part to monitor application performance.

## Notable Engineering

### Data Model Design

Different from OOD we designed our data model by the use in service unit to reduce the access of database for one request. Also, the operation of relationship between models like join is limited to the minimum level, we store the data simply as a key-value pair. 

Data is stored in a MongoDB, a NoSQL database, as nested JSON-like "documents."  The primary model is the User model, assigned to registered users of the nanoTwitter app, that contains pertinent information such as username, email, encrypted password, and API token.  Each User has a nested Profile document containing more user details such as name, location, birthday, and biography.  Each User also contains a list of Tweet ids, each linked to a Tweet document.  Tweets contain 280-character content, the author id, the author handle.  Tweets also contains a list of ids to its reply Tweets.  A Tweet can be a Retweet of another Tweet.  The Tweet's original_tweet_id field is used to denote if the Tweet is a Retweet of another Tweet.  A Hashtag consists of a keyword and a list of Tweet documents that contain the Hashtag.


### Architecture Design
We noticed that the communication cost between microservices is much larger than the one between two dynos in the same server. In other words,  an HTTP call (a hop) between two servers at different locations would cost more time than working in the same server.

We noticed that the communication cost between microservices is much larger than the communication cost between two dynos in the same server. In other words,  an HTTP call (a hop) between two servers at different locations would cost more time than working in the same server.

So we implemented a web dyno which receives HTTP traffic from the routers and a worker dyno used for background jobs. (Note that one web dyno and one worker dyno is the maximum dynos we get without paying)

### Worker Dyno & Sidekiq
To make a response to a client faster, we only update the data in redis when necessary and put the job of mongodb update into a queue (using Sidekiq) and reply to the client. Asynchronously, the worker dyno fetches a job from the queue and update the mongodb as a background job.

### Rack Timeout
We also use Rack Timeout to abort requests which will take more than 5 seconds. The reason we do this is to avoid web requests which run longer than 5000ms. We either put the job in a queue for worker node to process or abort those requests so we can focus the resources to process other incoming reqeusts.

### Multithreading and JRuby (not used in final version)
We also consider the approach to distribute the load of main thread to multiple background thread. Since original Ruby interpreter was written in C and has some issues in multithreading jobs, we also applied [JRuby](http://jruby.org/) engine to run the code on JVM which has better controlls of multiple thread which can scale them to many cpus, cores etc.

We did the performance expriment of JRuby, the result shows that it improves the performance for reducing the load of main thread. However, in our application we also introduced the worker dyno which releases the load of main job. So we only applied worker dyno as background job worker in our application.

## Screenshots

#### Homepage
![nanoTwitter Homepage](/doc/img/screenshot01.png)

#### Timeline

![nanoTwitter User Timeline](/doc/img/screenshot02.png)

#### Create Tweet

![nanoTwitter Tweet](/doc/img/screenshot03.png)

#### User Page

![nanoTwitter User Page](/doc/img/screenshot04.png)

#### Follower List

![nanoTwitter Followers Page](/doc/img/screenshot05.png)


## Result of scalability work, timings

### Scaled with worker dyno

We scaled our application by applying the worker dyno, in the way that our applications transferred the computational intensive tasks from web layer to background to improve the performance of responde time back to client. We compared the performance before and after we applied the worker dyno, the performance was improved by this scaling up.

![500 clients over 1 min without worker dyno](/doc/tests/500_create_new_tweet_web1thread1.png)
*0 - 500 clients over 1 min, maintain client load, tweet route, with only one web dyno, no worker dyno added*

![500 clients over 1 min with worker dyno](/doc/tests/500_create_new_tweet_web1worker1thread1.png)
*0 - 500 clients over 1 min, maintain client load, tweet route, with one web dyno and one worker dyno*

### Applying Rack Timeout

The requset which takes too long time also will affect the subsequent jobs since all the jobs are waiting in the job queue, once the first one takes too long time and exceeds the time of timeout, as a chain effect all the subsequent jobs will fall in the timeout error too. For solving this problem, we implemented our application with [Rack::Timeout](https://github.com/heroku/rack-timeout) , this library will abort the request that are taking too long time and let the susequent jobs to execute.

We compared the number of timeout before and after the setting of Rack Timeout. Long time taking request yields to the next job reduced the number of timeout requests in total. 

![1000 clients over 1 min with worker dyno, no Rack Timeout](/doc/tests/1000_create_new_tweet_web1worker1thread1_no_timeout.png)
*0 - 1000 clients over 1 min, maintain client load, tweet route, with one web dyno and one worker dyno, not using Rack:Timeout*

![1000 clients over 1 min with worker dyno, with Rack Timeout](/doc/tests/1000_create_new_tweet_web1worker1thread1_timeout.png)
*0 - 1000 clients over 1 min, maintain client load, tweet route, with one web dyno and one worker dyno, using Rack:Timeout*

### Limit in Redis
In this application, we store the timeline of each user in Redis. This algorithm is also being used by Twitter for storing their users' timeline. In this algorithm, once a user creates a new tweet, this new created tweet will be broadcasted to all followers and update each follower's timeline.

We searched all the free Redis add-on for heroku cloud framework, in which the best option is [Redis Cloud](https://elements.heroku.com/addons/rediscloud) with the largest memory size and connection allowed. However, for the need of our application in creating new tweet, this server provided Redis Cloud reache the maximum connection limit and the test failed. Below is the load test performance and Redis server state, the maximum connection for this free plan is 30.

Therefore, 

![500 clients over 1 min create new tweets](/doc/tests/create_new_tweet_500_failed.png)
![Redis Error Message](/doc/tests/Redis_Error_message.png)
![Redis Connection reached maximum number](/doc/tests/Redis_Error_message.png)

## Team Members

Si Chen, Alyssa Goncalves, Shuai Yu

COSI-105b Software Engineering for Scalability

Brandeis University, Spring 2018

## API and Client Library

nanoTwitter has a REST API that can be utilized with the [nanoTwitter Client Library](https://github.com/amgoncalves/nt-client) for client applications written in Ruby.  The following routes are implemented in the nanoTwitter API:

Tweet

```
GET "/api/v1/:apitoken/tweets/:id"
GET "/api/v1/:apitoken/tweets/recent"
POST "/api/v1/:apitoken/tweets/new"
POST "/api/v1/:apitoken/tweets/:id/reply"
POST "/api/vi/:apitoken/tweets/:id/retweet"
```

User

```
GET "/api/v1/:apitoken/users/:key"
GET "/api/v1/:apitoken/users/:key/tweets"
GET "/api/v1/:apitoken/users/:key/followers"
GET "/api/v1/:apitoken/users/:key/following"
POST "/api/v1/:apitoken/users/:key/follow"
POST "/api/v1/:apitoken/users/:key/unfollow"
```

Search:

```
POST "/api/v1/:apitoken/search/:key/users"
POST "/api/v1/:apitoken/search/:key/tweets"

```

## Installation and Setup

### MongoDB Setup

Install [MongoDB Community Edition](https://docs.mongodb.com/manual/administration/install-community/).  The installation guide for nanoTwitter uses MacOS instructions in the examples.  See the relevant installation pages to find equivalent installation and operation instructions for [Windows](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/) and [Linux](https://docs.mongodb.com/manual/administration/install-on-linux/).
 
To start, run MongoDB in the shell using one of the following three options:

* ```$ mongod``` to run without specifying paths.

* ```$ <path to binary>/mongod``` if your system PATH does not include the location of the MongoDB binary.

* ```$ mongod --dbpath <path to data directory>``` if you chose to use a custom data directory path during installation.

MongoDB must be running on the development machine for the app to work locally.  If MongoDB has started successfully, the following line will appear in the process output:

```[initandlisten] waiting for connections on port 27017```

Create a new development database.  Open a new shell and start the MongoDB shell:

```$ mongo --host 127.0.0.1:27017```

In the MongoDB shell, create a new database named ```nanotwitter-test```:

```
>use nanotwitter-test
switched to db nanotwitter-test
```

The default configuration of the development database is contained in the file config/mongoid.yml.  If you'd like to use a custom development setup, you can edit mongoid.yml and add config/mongoid.yml to your .gitignore file.

### Redis Setup
* [Download](https://redis.io/download), extract and compile Redis with:
````
$ tar xzf redis-4.0.8.tar.gz
$ cd redis-4.0.8
$ make
````
* The binaries compiled are available in the src directory. Run Redis with:
````
$ src/redis-server
````
* You can interact with Redis using the built-in client:
````
$ src/redis-cli
redis> flushall       # delete all data in redis
OK
redis> keys *         # show all keys stored in redis
redis> lrange "key" 0 -1          # show all elements stored in the "key" as a list
````
### Sidekiq Setup
Sidekiq is used to handle the backgroud jobs, before starting Sinatra application, we need starting Sidekiq first.
```
$ gem install sidekiq
$ bundle exec sidekiq -r ./app.rb
```

### Sinatra Setup

Download the [repo](https://github.com/amgoncalves/sassy-twitter).  Use [Bundler](http://bundler.io/) to install the required project Gems by running the following command from the project's root directory:

```$ bundle install```

Make sure MongoDB is running according to the instructions given in **MongoDB Setup**.

Start Sidekiq by running the following the command:

```$ bundle exec sidekiq -r ./app.rb```

To launch the app, run the following command in the project's root directory:

```$ ruby app.rb```

Open a web browser and navigate to ```localhost:4567```.  You should see the nanoTwitter homepage.


## Documentation

This project has a [developer's Wiki](https://github.com/amgoncalves/sassy-twitter/wiki).


## Version

nT1.0


## License

This project is licensed under the [MIT License](https://github.com/amgoncalves/sassy-twitter/blob/master/license.txt).


## Acknowledgments

We would like to thank Professor Pito Salas, Zach Weis, and Ian Leeds for their invaluable guidance in the completion of this project.


## Last Modified

April 25, 2018
