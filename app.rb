require 'sinatra'
require 'sinatra/reloader'
require 'pry'

before do
  @db = PG.connect(dbname: 'memetube', host: 'localhost')
end

after do
  @db.close
end

get '/' do
  redirect to '/videos/'
end

get '/videos/' do
  erb :index
end