require 'rubygems'
require 'sinatra'

before do
  headers "Content-Type" => 'text/html; charset=utf-8'
end

get '/' do
  erb :index, :layout => false
end