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

get '/get_session' do
  # env['rack.session.options'].inspect # session object options including [:id]
  $pool.inspect # display updated session object
end

get '/set_session' do
  # merege any GET params into the session e.g. ?foo=bar = {"foo" => "bar"}
  # matching keys will have there values overwritten e.g. ?foo=baz&key=value = {"foo" => "baz", "key" => "value"}
  session.merge!(params)
  $pool.inspect
end

get '/renew_session' do
  env['rack.session.options'][:renew] = true # new session id, maintains existing session object
  $pool.inspect
end

get '/drop_session' do
  env['rack.session.options'][:drop] = true # new session id, empty session object
  $pool.inspect
end