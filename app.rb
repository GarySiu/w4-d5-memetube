require 'sinatra'
require 'sinatra/reloader' if production?
require 'pry'
require 'pg'

before do
  @db = PG.connect(dbname: 'memetube', host: 'localhost')
end

after do
  @db.close
end

get '/' do
  redirect to '/videos/'
end

get '/videos/' do # index
  sql = 'SELECT * FROM VIDEOS'
  @videos = @db.exec(sql)
  erb :index
end