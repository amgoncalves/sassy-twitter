# nanoTwitter 1.0 :bird:

[https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/)

Si Chen, Alyssa Goncalves, Shuai Yu

COSI-105b Software Engineering for Scalability

Brandeis University, Spring 2018

## Change History


### nt0.1 - Foundation

#### Developer's Log

- [x] License file and documentation for routes and sql database schema were added to the repo.  This was done together as a group.
- [x] A pilot project (pilot-project/mongo-evite) using mongodb was added by Shuai.
- [x] UI design and prototype is completed by Si.


### nt0.2 - First Minimal Implementation

#### Requirements

* *[SINATRA]* - The skeleton app's routes are in ```app.rb```.  Templates are in ```views```.   Mongoid ODMs (Object-Document-Mappers) are in ```models```.  Stylesheets and images are in ```public```.

* *[MIGRATIONS]* - MongoDB does not use migrations.

* *[AUTHENTICATION]* - We used BCrypt and enabled Sinatra's default sessions with cookies to accomplish user authentication.  A user is authenticated using the ```auth_user``` method, which checks a password against the stored BCrypt password_hash for that user in the database.  The user is stored in ```session[:user]``` if authentication succeeds.  Routes are marked as protected by calling ```authenticate!```.  For now, this is a secret page, ```/users```, that displays a list of all users who have registered for nanoTwitter.  When a user logs out, they are removed from the session.

* *[HEROKU]* - [https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/)  Authentication can be tested by creating an account, logging in, and logging out.  Visitors can also post a Tweet.

* *[nanoTwitter 0.2]* - Release has been tagged by naming the project nanoTwitter 0.2 and updating ```version.rb```.

#### Developer's Log

- [x] Create Heroku account and documentation is done by Alyssa.
- [x] Change sql database schema to nonsql database sql by Shuai and Si.
- [x] A pilot project (pilot-project/sinatra-bootstrap-master) testing navigation bar feature was added by Shuai.
- [x] A pilot project (pilot-project/twitterwhack_test) testing the hover card feature was added by Shuai.
- [x] The database models of User, Profile and Hashtag were implemented and tested by Shuai.
- [x] The database modesl of Tweet, Reply were implemented and tested by Si.
- [x] Added some basic functions related to Tweet and Reply models by Si
- [x] Heroku and mLab setup, login/logout routes, sessions, BCrypt added by Alyssa
- [x] API design document and Swagger API are implemented by Si


### nt0.3 - Core Functionality

### Requirements

* *[UNITTESTS]* - Unit tests using Rack and MiniTest Spec were added to the folder ```spec```.  ```Rakefile``` was added with a script to run all tests in this folder.

* *[TESTINTERFACE]* - Test interface added to ```spec/loadtest.rb```.

* *[CODESHIP]* - Created a Codeship project and setup to run rake tests when code is pushed to the GitHub repo's master branch.

* *[STANDARDSEEDS]* - Seeds were downloaded and added to the ```seeds``` directory.  ```spec/loadtest.rb``` loads the seeds into the database.

* *[AUTODEPLOY]* - Once Codeship has verified that all of the unit tests pass, the repo is deployed to the production site on Heroku: [https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/)

* *[nanoTwitter 0.3]* - Release has been tagged by naming the project nanoTwiter 0.3 and updating ```version.rb```.

#### Developer's Log

- [x] Codeship setup and autodeploy was setup by Alyssa.
- [x] Seeds and test interfaces for load test were completed by Si.
- [x] Some unit tests, integration tests were done by Shuai
- [x] User page, following page, followers page were implemented by Shuai
- [x] The navigation bar using Bootstrap on user page, following page, followers page was implemented by Shuai
- [x] Follow button using jquery was done by Shuai
- [x] The HTML and CSS template for user page, following page, followers page, timeline page was got by tweaking an open-source template, done by Shuai

### nt0.4 - Testing and Deployment

### Requirements

* *[MANUALTEST]* - All three team members log into it at the same time and do some tweeting.

* *[TESTINTERFACE]* - Implement the complete test interface from the nano Twitter Functionality. 

* *[LOADTEST]*  - Use loader.io to generate some artificial loads. Play around with different loads. 

* *[MORETESTS]* - Using load testing, discover actual bugs in the code.

* *[nanoTwitter 0.4]* - Double check that you are up to date on everything that came before this. Clean up the directory. Update your repo with your latest and tag the release.

#### Developer's Log

- [x] Unit tests or integration tests for login, authentication, user page, followings page, followers page, follow, new tweet, reply, retweet, were done by Shuai
- [x] Make sure all the tests passed on codeship, no bugs left, done by Shuai
- [x] Log in at the same time and do manual testing, done by All
- [x] Implement the complete test interface, done by Si.
- [x] Completed Load Test of loading all seed files into local databases, 1000 users, 100715 tweets using 596 seconds by Si.
- [x] Use Rest Client to do kinds of Load Tests of generating different users, tweets and follows by Si.
- [x] Add the generated token file from loader.io into the heroku server, and verify it, done by Shuai
- [x] Write ruby program to generate payload file from the seed data, done by Shuai
- [x] Do load testing using the payload file. Note: the payload file can only be as large as 3MB. done by Shuai
- [x] Set Redis cache service both in local and Heroku by Si
- [x] Implemented caching the timeline in Redis by Si
- [x] Debugging codeship and Heroku deployment done by Alyssa
- [x] Cleaned up layout for manual testing done by Alyssa
- [x] Site-wide Bootstrap, templates, and CSS done by Alyssa
- [x] Clean up the directory, update repo and submit.

### nt0.5 - Initial Load Testing

### Requirements
* *[INSTRUMENT]* - Collect internal performance and timing data using New Relic

* *[RUNLOADEXPERIMENT]* - Design specific experiments and see whether a change improves performance. Keep up your notes in a text file inside your github repo.

* *[NEWWEB]* Switch web server from WebBrick; try others, measure.

* *[IMPROVESCHEMA]* Update your schema to put indexes and other enhancements and see effects.

* *[nanoTwitter 0.5] Clean up, update readme.md and your repo with latest and tag the release.

#### Developer's Log

- [x] Enable New Relic within Heroku Configuration and begin collecting internal performance and timing data -Shuai
- [x] MongoDB index, done by Shuai and Si
- [x] Improved scheme of user model - Shuai
- [x] Added hover card feature on user page - Shuai
- [x] Reimplemented follow button using Ajax, only POST when unload the page - Shuai
- [x] Hello world sinatra app (jruby) running on JVM - Shuai 
- [x] Implemented the function and related page of like - Si
- [x] Implemented the function and related page of retweet - Si
- [x] Implemented the function and related page of reply - Si
- [x] Implemented the function and related page of tweet detail - Si
- [x] Improved schema of reply and tweet and generated summary of code optimization to ensure least access to database and efficiency of get method - Si
- [x] Switched server from WEBrick to Puma - Alyssa
- [x] Implemented search (users and tweets) - Alyssa
- [x] Moved registration from front page to /signup, added signup to navbar - Alyssa
- [x] Added scrolling list of all tweets to the front page for unauthenticated users - Alyssa

### nt0.6 - Advanced Scaling

### Requirements
* *[REDIS]* - Setup Redis caching service, locally and on heroku

* *[CACHING]* - Add caching and do experiments to see the effect

* *[SCALEEXPERIMENT]* - Do scaling experiments to see the differences (keep a record)

* *[nanoTwitter 0.6]* - Clean up directory. Update repo.

#### Developer's Log

- [x] Store the logged in user in redis, and make methods to retrive it and save it correctly - Shuai
- [x] Make sure redis works properly (unique key for each logged in user, user deleted in redis when logout) - Shuai
- [x] Load test for follow using payload file, including one logged in user follows many others, and many users follow many users - Shuai
- [x] Load test for creating users using playload file - Shuai
- [x] Change Profile model so that we can make an instance of it by hash parameters - Shuai
- [x] Benchmark load test (redis part) for comparison between mongo and redis - Shuai
- [x] Did experiments about using Bcrypt or not - Si and Shuai
- [x] Did experiments about including Profile in user model or not - Shuai
- [x] Changed the global redis key for user from currentUser to unique one for each user - Shuai
- [x] Implemented showing hash tag with link in tweet, reply and retweet and save it in mongodb and Hashtag list - Si
- [x] Implemented showing mention link in tweet, reply and retweet and save it under each tweet - Si
- [x] Load test for creating new tweet 2000 clients per min - Si
- [x] load test for replying new tweet 2000 clients per min - Si
- [x] load test for unlogged in user 5000 clients in 20 seconds with maintaining 250 client per second - Si
- [x] Optimised reply model with including replier handle - Si
- [x] Fix anomalies with the rule changed of get logged in user from redis all tweet related code - Si
- [x] Benchmark load test (mongo) with inplementing new modles and test interfaces and load test with creating 1000 user and 10000 tweets in mongodb for comparison CRUD between mongo and redis - Si
- [x] Benchmark load test (redis part) with inplementing new modles and test interfaces and load test with creating 1000 user and 10000 tweets in redis for comparison CRUD between mongo and redis - Si
- [x] Modified User handle link not show in unlogged in index - Si
- [x] Switched sessions and cookies to store user id instead of the entire user document - Alyssa
- [x] Search page fixes: removed follow buton from users list, adjusted template to fit new variables - Alyssa
- [x] Load test for searching for tweets 250 clients per min - Alyssa
- [x] Added a worker to launch a small Rake background task for microservice experiment - Alyssa

### nt0.7 - Web Service API and Client

### Requirements
* *[APIROUTES]* - Implement Design external REST API urls as further Sinatra routes using Swagger

* *[CLIENTLIB]* - Write client libraries for APIs

* *[CLIENTLIBTEST]* - Write a complete set of tests for client library

* *[nanoTwitter 0.7]* - Clean up directory. Update repo.

#### Developer's Log

- [x] Config Procfile and add one worker dyno for heroku server - Shuai
- [x] Add Sidekiq to work with worker dyno, double loadtest performance -Shuai
- [x] Applied and test Jruby engine and muliple thread for database store function as backgroud job - Si
- [x] Completed Api routes of external REST API Design in Swagger -Si
- [x] Optmized tweet related functions - Si
- [x] Implemented Client library - Alyssa
- [x] Implemented a set of test for client library - Alyssa

### nt1.0 - Completion

### Requirements
* *[MICROSERVICE]* - Refactor one bit of functionality from your main Sinatra app into a separate microservice

* *[CODECLIMATE]* - Do a static code anlysis by submitting source code to Code Climate

* *[CLEANUP]* - Do whatever clean up of the source code

* *[PREPARE]* - Prepare for the final Scalability Runoff

* *[nanoTwitter 1.0]* - Clean up directory. Update repo.

#### Developer's Log
- [x] Added Rack:Timeout to improve loadtest performance - Shuai
- [X] Tried to add Redis Timeout to avoid redis connection limits - Shuai
- [x] Reconstruct the setup test interface with new requirement - Si
- [x] Prepare the test interface for final runoff - Shuai, Si
- [x] Clean up and recheck the source code - Shuai, Si
- [x] Write Report - Alyssa, Si, Shuai
- [x] Make the portforlio page - Alyssa, Shuai, Si
- [x] Add Code Climate badge - Si
- [x] Do the final load test as senario - Si, Alyssa, Shuai
- [x] Tuning performance based on the result of load test - Si, Alyssa, Shuai
- [x] Reconstruct global timeline storage from redis to mongodb and test the Redis connection limit - Si, Shuai
- [x] Reconstruct personal timeline algorithm and test the improvement in Redis connection limit - Si

## Documentation

This Github has a [developer's Wiki](https://github.com/amgoncalves/sassy-twitter/wiki).

## Installation Instructions

### MongoDB Setup

Install [MongoDB Community Edition](https://docs.mongodb.com/manual/administration/install-community/).  This Wiki uses MacOS instructions in the examples.  See the relevant installation pages to find equivalent installation and operation instructions for [Windows](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/) and [Linux](https://docs.mongodb.com/manual/administration/install-on-linux/).
 
To start, run MongoDB in the shell using one of the following three options:

* ```$ mongod``` to run without specifying paths.

* ```$ <path to binary>/mongod``` if your system PATH does not include the location of the MongoDB binary.

* ```$ mongod --dbpath <path to data directory>``` if you chose to use a custom data directory path during installation.

MongoDB must be running on the development machine for the app to work locally.  If MongoDB has started successfully, the following line will appear in the process output:

```[initandlisten] waiting for connections on port 27017```

Create a new development database.  Open a new shell and start the MongoDB shell:

```$ mongo --host 127.0.0.1:27017```

In the MongoDB shell, create a new database named ```nanotwitter-dev```:

```
>use nanotwitter-dev
switched to db nanotwitter-dev
```

The default configuration of the development database is contained in the file config/mongoid.yml.  If you'd like to use a custom development setup, you can edit mongoid.yml and add config/mongoid.yml to your .gitignore file.


### Redis Setup

Download and install [Redis](https://redis.io/topics/quickstart).  Redis must be running in the development environment.  Run the command ```$ redis-server``` in terminal.


### Sinatra Setup

Download this repo.  Use [Bundler](http://bundler.io/) to install the required project Gems by running the following command from the project's root directory:

```$ bundle install```

Make sure MongoDB is running according to the instructions given in **MongoDB Setup**.  To launch the app, run the following command in the project's root directory:

```$ ruby app.rb```

Open a web browser and navigate to ```localhost:4567```.  You should see the nanoTwitter homepage.

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
