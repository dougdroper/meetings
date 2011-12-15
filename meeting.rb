require 'rubygems'
require "sinatra"
require 'haml'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/meeting.db")

class MeetingRoom
  include DataMapper::Resource

  property :id,        Serial
  property :name,      String
  property :size,      Integer
  property :is_active, Boolean
end

DataMapper.auto_upgrade! 

before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

get '/' do
end

get '/meeting_rooms' do
	@rooms = MeetingRoom.all
	haml :rooms
end

get '/create_meeting_room' do
  haml :create_room
end

post '/create_meeting_room' do
  MeetingRoom.create(:name => params[:name], :size => params[:size], :is_active => params[:is_active])
  redirect '/meeting_rooms'
end

