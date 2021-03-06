require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash=true
end

configure do
  init_db
  @db.execute 'CREATE TABLE IF NOT EXISTS posts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            created_date DATE,
            content TEXT         )'
  @db.execute 'CREATE TABLE IF NOT EXISTS comments(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            post_id INTEGER,
            created_date DATE,
            content TEXT         )'

end

before do
  init_db
end

get '/' do
  @results = @db.execute'select * from posts order by id desc'
  erb :index
end

get '/about' do
  @message = "There should be information about us"
  erb :message
  #erb "<div class=\"jumbotron text-center\"> About us information </div><h1></h1>"
end

get '/new' do
  #@message = "There should be NEW FORM"
  erb :new
end

post '/new' do
  con = params[:content]
  if con.strip.empty?
    @error = 'Please, type some text'
    erb :new
  else
    #saving data to db
    @db.execute 'insert into posts (content, created_date) values (?, datetime())', [con]
    redirect to '/'
    erb "You typed #{con}"
  end
end

#post details information
get '/details/:post_id' do
  #@message = "You typed #{params[:post_id]}"
  post_id = params[:post_id]
  results = @db.execute'select * from posts where id = ?', post_id
  @row = results[0]
  @comments = @db.execute'select * from comments where post_id = ? order by id', post_id
  erb :details
end

post '/details/:post_id' do
  con = params[:comment]
  post_id = params[:post_id]
  @message = "You typed #{con} to post #{post_id}"
   if con.strip.empty?
     @error = 'Please, type comment text'
   else
     #saving data to db
     @db.execute 'insert into comments (content, created_date, post_id) values (?, datetime(), ?)', [con, post_id]
     #erb "You typed #{con}"
   end
  redirect to ('/details/' + post_id)
  #erb :message
end

