# nanoTwitter :bird:

COSI-105b Software Engineering for Scalability

Brandeis University, Spring 2018

Si Chen, Alyssa Goncalves, Shuai Yu

## Change History

### nt0.1

* License file and documentation for routes and database schema were added to the repo.  This was done together as a group.
* A pilot project (pilot-project/mongo-evite) using mongodb was added by Shuai.
* UI design and prototype is completed by Si.

### nt0.2

* Create Heroku account and documentation is done by Alyssa.

## Documentation

This Github has a [developer's Wiki](https://github.com/amgoncalves/sassy-twitter/wiki)

## Instructions

### MongoDB Setup

[Install MongoDB](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/) on your local development environment.  Launch according to the instructions found under "Run MongoDB".  Create a development database named ```nanotwitter-dev``` to match the development environment configuration in ```config/mongoid.yml```.

### App Setup

Download this repo.  In the project root, run ```bundle install``` to install the related Gems.    To launch the app, run ```ruby app.rb``` and navigate to ```localhost:4567``` in your preferred web browser.