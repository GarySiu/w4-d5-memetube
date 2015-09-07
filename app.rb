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
  sql = 'SELECT * FROM videos ORDER BY id DESC' #Most recently added videos first
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

    #We need to select again to get the video's id to redirect the user to the video's new show page
    #This gets super convoluted because we need to get the value out the enumerable.

    sql = "SELECT id FROM videos WHERE video_id = '#{params[:video_id]}'"
    videos = @db.exec(sql)
    id = ''
    videos.each { |video| id = video['id']}
    redirect to "/videos/#{id}"

  elsif params[:video_id]['youtu.be/'] #otherwise look for a shortened youtube link
    params[:video_id] = params[:video_id].slice(params[:video_id].index('.be/')+4, 11)

    sql = "INSERT INTO videos (title, video_id, description, views) VALUES ('#{params[:title]}', '#{params[:video_id]}', '#{params[:description]}', 1)"
    @db.exec(sql)

    sql = "SELECT id FROM videos WHERE video_id = '#{params[:video_id]}'"
    videos = @db.exec(sql)
    id = ''
    videos.each { |video| id = video['id']}
    redirect to "/videos/#{id}"

  else
    @error = 'Invalid youtube video id.'
    erb :new #This doesn't seem to work if I redirect to /videos/new. It seems to wipe the instance variable.
  end
end

get '/videos/random' do #Got to be before the show page or it will get overridden
  sql = "SELECT * FROM videos"
  videos = @db.exec(sql)
  all_videos = []

  videos.each do |video|
    all_videos << video['id']
  end

  redirect to "/videos/#{all_videos.sample}"
end

get '/videos/:id' do #show
  sql = "SELECT * FROM videos WHERE id = #{params[:id]}"
  @videos = @db.exec(sql)
  erb :show
end

get '/videos/:id/delete' do #delete/destroy
  sql = "DELETE FROM videos WHERE id = #{params[:id]}"
  @db.exec(sql)
  redirect to '/videos/'
end

get '/videos/:id/edit' do #edit
  sql = "SELECT * FROM videos WHERE id = #{params[:id]}"
  @db.exec(sql)
  @videos = @db.exec(sql)
  erb :edit
end

post '/videos/:id' do #update
  # Safety first!
  params[:title].gsub!("'", "''")
  params[:description].gsub!("'", "''")

  if params[:video_id]['youtube.com/watch?v='] # try to detect if it's a usable normal youtube link
    params[:video_id] = params[:video_id].slice(params[:video_id].index('=')+1, 11)

    sql = "UPDATE videos SET title = '#{params[:title]}', description = '#{params[:description]}', video_id = '#{params[:video_id]}' where id = #{params[:id]}"
    @db.exec(sql)

    redirect to "/videos/#{params[:id]}"

  elsif params[:video_id]['youtu.be/'] #otherwise look for a shortened youtube link
    params[:video_id] = params[:video_id].slice(params[:video_id].index('.be/')+4, 11)

    sql = "UPDATE videos SET title = '#{params[:title]}', description = '#{params[:description]}', video_id = '#{params[:video_id]}' where id = #{params[:id]}"
    @db.exec(sql)

    redirect to "/videos/#{params[:id]}"

  else
    # I can't work out a good way to pass an error out so for now the user silently goes back to the show page.
    # Other params are updated but not video ID.

    sql = "UPDATE videos SET title = '#{params[:title]}', description = '#{params[:description]}' where id = #{params[:id]}"

    redirect to "/videos/#{params[:id]}"
  end
end