# nanoTwitter

[https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/)

nanoTwitter (nT) is a minimal version of [Twitter](https://twitter.com/) built on [Sinatra](http://sinatrarb.com/).

## Authors

Si Chen, Alyssa Goncalves, Shuai Yu

COSI-105b Software Engineering for Scalability

Brandeis University, Spring 2018

## Feature Summary

Users who register for an account can broadcast short 280-character messages to the site-wide global timeline.  Each user has a unique username, called a handle, and a profile page with a log of their messages.  Users can follow other users to customize what messages they see in their personal feed.  Users have the ability to duplicate or "re-Tweet" any message onto their own timeline with an optional comment.  Prefixing a word with the pound or hashtag (#) symbol makes the term searchable by other users.  Search is available  for other users by their handle or search for tweets by keyword.  Optional cookies are used for persistent user sessions.

This application is optimized to scale as the load of users increase.  Caching, multi-threading, and a lightweight NoSQL database are employed to manage scalability problems.

## Technology Description

nanoTwitter is written in [Sinatra](http://sinatrarb.com/) and runs on the [JRuby](http://jruby.org/) engine.  [Git](https://git-scm.com/) and [Github](https://github.com/amgoncalves/sassy-twitter) are used for version control.  The application is hosted on a [Heroku](https://www.heroku.com/) server at [https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/).  [Codeship](https://codeship.com/) is used to automate testing and deployment from Github.

Application data is stored in a [MongoDB Community Server](https://www.mongodb.com/) database and uses the [mLab](https://mlab.com/) service on the production server.  The [Mongoid](https://docs.mongodb.com/mongoid/master/#ruby-mongoid-tutorial) ODM (Object-Document-Mapper) is used to convert between Sinatra-compatable abstract data types and MongoDB documents.  Data is cached in-memory using [Redis](https://redis.io/).

The UI uses a combination of HTML and [embedded Ruby](https://ruby-doc.com/docs/ProgrammingRuby/html/web.html).  Elements are styled in CSS using [Bootstrap](https://getbootstrap.com/). [JQuery](https://jquery.com/) is used to give some UI elements additional functionality.

## Notable Engineering

## Loader Test Data and Results

## Installation and Setup

## Version

nT1.0

## License

This project is licensed under the [MIT License](https://github.com/amgoncalves/sassy-twitter/blob/master/license.txt).

## Acknnowledgments

## Last Modified

April 19, 2018