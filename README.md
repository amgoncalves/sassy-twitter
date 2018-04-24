# Summary Statement of Assignment 

[https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/)

nanoTwitter (nT) is a minimal version of [Twitter](https://twitter.com/) built on [Sinatra](http://sinatrarb.com/).

Users who register for an account can broadcast short 280-character messages to the site-wide global timeline.  Each user has a unique username, called a handle, and a profile page with a log of their messages.  Users can follow other users to customize what messages they see in their personal feed.  Users have the ability to duplicate or "re-Tweet" any message onto their own timeline with an optional comment.  Prefixing a word with the pound or hashtag (#) symbol makes the term searchable by other users.  Search is available  for other users by their handle or search for tweets by keyword.  Optional cookies are used for persistent user sessions.

This application is optimized to scale with the load of user activity.  Caching, multi-threading, and a lightweight NoSQL database with in-memory data caching are employed to manage scalability problems.

nanoTwitter has a REST API that can be utilized with the [nanoTwitter Client Library](https://github.com/amgoncalves/nt-client) for client applications written in Ruby.

## Screenshots


## Technology Description

We build full stack web application in Sinatra framework with high functional data storage system MongoDB and Redis, and frequent intergration of code using Codeship.
* nanoTwitter is written in [Sinatra](http://sinatrarb.com/) and runs on the [JRuby](http://jruby.org/) engine.  
* [Git](https://git-scm.com/) and [Github](https://github.com/amgoncalves/sassy-twitter) are used for version control.  
* The application is hosted on a [Heroku](https://www.heroku.com/) server at [https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/).  
* [Codeship](https://codeship.com/) is used to automate testing and deployment from Github.
* Application data is stored in a [MongoDB Community Server](https://www.mongodb.com/) database and uses the [mLab](https://mlab.com/) service on the production server.  The [Mongoid](https://docs.mongodb.com/mongoid/master/#ruby-mongoid-tutorial) ODM (Object-Document-Mapper) is used to convert between Sinatra-compatable abstract data types and MongoDB documents.  Data is cached in-memory using [Redis](https://redis.io/).
* The UI uses a combination of HTML and [embedded Ruby](https://ruby-doc.com/docs/ProgrammingRuby/html/web.html).  Elements are styled in CSS using [Bootstrap](https://getbootstrap.com/). [JQuery](https://jquery.com/) is used to provide additional functionality to certain UI elements.
* Load testing was accomplished by using [loader.io](https://loader.io/) to stress the application with thousands of concurrent connections. [New Relic](https://newrelic.com/) was used in part to monitor application performance.

## Interesting Engineering

We noticed that the communication cost between microservices is much larger than the one between two dynos in the same server. In other words,  an HTTP call (a hop) between two servers at different locations would cost more time than working in the same server.

So we have a web dyno which receives HTTP traffic from the routers and a worker dyno used for background jobs. (Note that one web dyno and one worker dyno is the maximum dynos we get without paying)

To make a response to a client faster, we only update the data in redis when necessary and put the job of mongodb update into a queue (using Sidekiq) and reply to the client. Asynchronously, the worker dyno fetches a job from the queue and update the mongodb as a background job.

We also use Rack Timeout to abort requests which will take more than 5 seconds. The reason we do this is to avoid web requests which run longer than 5000ms. We either put the job in a queue for worker node to process or abort those requests so we can focus the resources to process other incoming reqeusts.

## Result of scalability work, timings

![500 clients over 1 min](https://raw.githubusercontent.com/username/projectname/branch/path/to/img.png)
Before adding a worker dyno

After adding a worker dyno

Before using Rack Timeout

After using Rack Timeout

## Team Members

Si Chen, Alyssa Goncalves, Shuai Yu

COSI-105b Software Engineering for Scalability

Brandeis University, Spring 2018

## Dates

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

### Sinatra Setup

Download the [repo](https://github.com/amgoncalves/sassy-twitter).  Use [Bundler](http://bundler.io/) to install the required project Gems by running the following command from the project's root directory:

```$ bundle install```

Make sure MongoDB is running according to the instructions given in **MongoDB Setup**.  To launch the app, run the following command in the project's root directory:

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

April 19, 2018
