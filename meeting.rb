require 'rubygems'
require "sinatra"
require 'haml'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/meeting.db")

class MeetingRoom
  include DataMapper::Resource
  has n, :bookings

  property :id,        Serial
  property :name,      String
  property :size,      Integer
  property :is_active, Boolean
end

class Booking
  include DataMapper::Resource
  belongs_to :meeting_roooms

  property :id,             Serial
  property :date,           DateTime
  property :ouside_meeting, Boolean
  property :booker_name,    String
  property :cancelled,      Boolean, :default => false
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

get '/make_booking/:id' do
  @meeting_room = MeetingRoom.find(params[:id])
  @bookings = @meeting_room.bookings
  haml :make_booking
end