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
end

before do
  init_db
end

get '/' do
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
    @db.execute 'insert into posts (content, created_date) values (?, datetime())', [con]
    erb "You typed #{con}"
  end
end
