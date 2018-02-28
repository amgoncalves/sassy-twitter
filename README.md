# nanoTwitter :bird:

[https://sassy-nanotwitter.herokuapp.com/](https://sassy-nanotwitter.herokuapp.com/)

Si Chen, Alyssa Goncalves, Shuai Yu

COSI-105b Software Engineering for Scalability

Brandeis University, Spring 2018

## Change History

### nt0.1

* License file and documentation for routes and database schema were added to the repo.  This was done together as a group.
* A pilot project (pilot-project/mongo-evite) using mongodb was added by Shuai.
* UI design and prototype is completed by Si.

### nt0.2

* Create Heroku account and documentation is done by Alyssa.

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

### Sinatra Setup

Download this repo.  Use [Bundler](http://bundler.io/) to install the required project Gems by running the following command from the project's root directory:

```$ bundle install```

Make sure MongoDB is running according to the instructions given in **MongoDB Setup**.  To launch the app, run the following command in the project's root directory:

```$ ruby app.rb```

Open a web browser and navigate to ```localhost:4567```.  You should see the nanoTwitter homepage.