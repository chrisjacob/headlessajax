# Sourced from: http://scottw.com/sinatra
# Goal:
# Ensure urls served by the application are consistent by requiring no trailing slash and requiring all urls to be lower cased. 
# If either one of these conditions are not met, the plugin will do a 301 redirect to the proper url.
  
require 'sinatra/base'
 
module Sinatra
  module ConsistentUrls
    
    def validate_url_requests()
      before {
        path = request.path.downcase
        path_to_redirect = nil
 
        #if the path ends in '/' remove it
        path_to_redirect =  path[0..-2] if /.+\/$/.match(path)
 
        #if the original path was not lower case. NOTE: we lowercase this above to minimize steps
        path_to_redirect = path if !path_to_redirect &&  path != request.path
 
        #if we need to redirect, build a query_string
        if(path_to_redirect)
          query_string =  hash_to_querystring(request.params)
          path_to_redirect << ("?" + query_string) if query_string
        end
 
        redirect path_to_redirect, 301 if path_to_redirect
      }
    end
    
    #borrowed from http://justanothercoder.wordpress.com/2009/04/24/converting-a-hash-to-a-query-string-in-ruby/
    def hash_to_querystring(hash)
      hash.keys.inject('') do |query_string, key|
        query_string << '&' unless key == hash.keys.first
        query_string << "#{URI.encode(key.to_s)}=#{URI.encode(hash[key])}"
      end
    
    end
  
  end
 
  register ConsistentUrls
end