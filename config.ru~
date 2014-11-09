require 'rest_client'
require 'base64'

use Rack::Session::Pool

RestClient.log = 'stdout'

client_id     = "TXA4vos9G8YM1VGUnFAGU9nTW3fxcgbN"
client_secret = "LAgmZaIGxKvOLHNk"
redirect_uri  = "http%3A%2F%2Fapp1-legallth.rhcloud.com%2Flogin"
redirect_uri2  = "http://app1-legallth.rhcloud.com/login"

map '/health' do
  health = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["1"]]
  end
  run health
end

map '/info' do
  health = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["Simple app to test Orange Partner API"]]
  end
  run health
end

map '/' do
  home = proc do |env|
    authent_url = "https://api.orange.com/oauth/v2/authorize?scope=openid&response_type=code&client_id=#{client_id}&state=ok&redirect_uri=#{redirect_uri}"
       [303, { "Cache-Control" => "no-cache, no-store, must-revalidate",
               "Pragma" => "no-cache",
               "Expires" => "0",
               "Location" => authent_url }, 
             ["My simple empty app. Authentication is required #{env['QUERY_STRING']}"]]
  end
  run home
end

map '/login' do
    login = proc do |env|
        check_auth_id =  /code=(.*)\&state=ok$/.match(env['QUERY_STRING'])
        if check_auth_id then
            authorization_code = check_auth_id[1]
            newToken = RestClient::Resource.new('https://api.orange.com/oauth/v2/token', :user => client_id, :password => client_secret)
            newToken.post({ :grant_type => "authorization_code", :code => authorization_code, :redirect_uri  => "#{redirect_uri2}" }) do |response, request, result| 
                if response.code == 200 then
                    [200, { "Content-Type" => "text/html" }, ["Autorization token has been fetched: #{response}"]]
                else
                    [200, { "Content-Type" => "text/html" }, ["Error while getting token: #{response}"]]
                end
            end
        else
            [200, { "Content-Type" => "text/html" }, ["Unexpected parameters in request: #{env['QUERY_STRING']}"]]
        end
    end
    run login
end

