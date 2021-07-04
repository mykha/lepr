require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
  @db = SQLite3::Database.new 'leprosorium.db'
  @db.results_as_hash=true
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
  @message = con
  erb "You typed #{con}"
end
