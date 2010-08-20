require 'rubygems'
require 'sinatra'

# Rack:Session:Pool for memory based sessions
# Monkey patching to make the pool a global variable for inspection at /show_session
# Referenced: http://stackoverflow.com/questions/1898952/sinatra-racksessionpool
class Rack::Session::Pool
  def initialize app,options={}
    super
    $pool=@pool=Hash.new
    @mutex=Mutex.new
  end
end

use Rack::Session::Pool

# Also consider Rack::Session::Datamapper for database based sessions
# http://github.com/pirj/rack-datamapper-session

before do
  headers "Content-Type" => 'text/html; charset=utf-8'
end

get '/' do
  erb :index, :layout => false
end

get '/set_session' do
  session.merge!(params)
  false # show a blank page
end

get '/show_session' do
  $pool.inspect
end