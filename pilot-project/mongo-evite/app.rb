require 'sinatra'
require 'mongoid'
require 'mongo'
require 'json'
require "sinatra/reloader" if development?
require 'byebug'

# require File.dirname(__FILE__) + '/vendor/gems/environment'
# Bundler.require_env

# set :mongo_db, 'mongoid_evite'

# Mongoid.load!("mongoid.yml", settings.environment)
Mongoid.load!("mongoid.yml")

# db = connect("localhost:27017/mongoid_evite")
# byebug

class Event
	include Mongoid::Document

	field :name, type: String
	field :date, type: Date
end

class Persn
	include Mongoid::Document

	field :name, type: String
	field :date_of_birth, type: Date
	field :gender, type: String
	field :zipcode, type: String
end

class Registration
	include Mongoid::Document

	field :person_id, type: Integer
	field :event_id, type: Integer
	field :status, type: String
end


get '/' do
	erb :index
end

# list all the persons
get '/persons' do
	@persons = Persn.all
	erb :list_persons
end

# create a new person
get '/person/new' do
	erb :person_new
end

# add the new person into db
post '/person/new/submit' do
	@person = Persn.new(params[:persn])
	if @person.save
		redirect '/persons'
	else
		'Sorry, no field can be blank and you cannot add the same person twice.'
	end
end

# list all the events
get '/events' do
	@events = Event.all
	erb :list_events
end

# create a new event
get '/event/new' do
	erb :event_new
end

# add the new event into db
post '/event/new/submit' do
	@event = Event.new(params[:event])
	if @event.save
		redirect '/events'
	else
		'Sorry, no field can be blank.'
	end
end

# list all the registrations
get '/registrations' do
	@registrations = Registration.all
	erb :list_registrations
end

# create a new registration
get '/registration/new' do
	erb :registration_new
end

# add the new registration into db
post '/registration/new/submit' do
	@registration = Registration.new(params[:registration])
	if @registration.save
		redirect '/registrations'
	else
		'Sorry, no field can be blank.'
	end
end
