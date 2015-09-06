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

get '/videos/new' do # new
  erb :new
end

post '/videos/' do # create
  # binding.pry
  # This whole section is obviously not DRY but I can't get it to work any other way

  params[:title].gsub!("'", "''")
  params[:description].gsub!("'", "''")
  # params[:genre].gsub!("'", "''") Not adding genre yet

  if params[:video_id]['youtube.com/watch?v='] # try to detect if it's a usable normal youtube link
    params[:video_id] = params[:video_id].slice(params[:video_id].index('=')+1, 11)

    sql = "INSERT INTO videos (title, video_id, description, views) VALUES ('#{params[:title]}', '#{params[:video_id]}', '#{params[:description]}', 1)"
    @db.exec(sql)

    redirect to '/videos/'

  elsif params[:video_id]['youtu.be/'] #otherwise look for a shortened youtube link
    params[:video_id] = params[:video_id].slice(params[:video_id].index('.be/')+4, 11)

    sql = "INSERT INTO videos (title, video_id, description, views) VALUES ('#{params[:title]}', '#{params[:video_id]}', '#{params[:description]}', 1)"
    @db.exec(sql)
    redirect to '/videos/'

  else
    @error = 'Invalid youtube video id.'
    erb :new #This doesn't seem to work if I redirect to /videos/new. It seems to wipe the instance variable.
  end
end
