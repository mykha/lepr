require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/about' do
  @message = "There should be information about us"
  erb :message
  #erb "<div class=\"jumbotron text-center\"> About us information </div><h1></h1>"
end

get '/new' do
  @message = "There should be NEW FORM"
  erb :new
end
