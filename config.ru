require 'rest_client'
require "base64"

use Rack::Session::Pool

client_id     = "TXA4vos9G8YM1VGUnFAGU9nTW3fxcgbN"
client_secret = "LAgmZaIGxKvOLHNk"

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
    authent_url = "https://api.orange.com/oauth/v2/authorize?scope=openid&response_type=code&prompt=login&client_id=#{client_id}&state=ok&redirect_uri=http%3A%2F%2Fapp1-legallth.rhcloud.com%2Flogin"
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
       consumer_key = Base64.encode64(client_id + ":" + client_secret)
       request = "curl -X POST -H \"Authorization: Basic #{consumer_key}\" -d \"grant_type=authorization_code&code=#{autorization_code}&redirect_uri=http://yourserver/page\" \"https://api.orange.com/oauth/v2/token\""

       [200, { "Content-Type" => "text/html" }, ["Request to get token: #{request}"]]
    else
       [200, { "Content-Type" => "text/html" }, ["Authorization failed"]]
    end       
  end
  run login
end
# https://api.orange.com/oauth/v2/authorize?scope=openid&response_type=code&client_id=6lkqGtxO0Cipb1aEVaAdEsglVkiSutwL&prompt=login%20consent&state=ok&redirect_uri=http%3A%2F%2Fapp1-legallth.rhcloud.com
