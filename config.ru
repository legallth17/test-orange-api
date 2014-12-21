require './orange_api'

use Rack::Session::Pool

orange_api = OrangeApi.new
orange_api.client_id     = "TXA4vos9G8YM1VGUnFAGU9nTW3fxcgbN"
orange_api.client_secret = "LAgmZaIGxKvOLHNk"
orange_api.redirect_uri  = "http://app1-legallth.rhcloud.com/login"

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
        # redirect to orange api authent_url
       [303, { "Cache-Control" => "no-cache, no-store, must-revalidate",
               "Pragma" => "no-cache",
               "Expires" => "0",
               "Location" => orange_api.authent_url }, 
             ["My simple empty app. Authentication is required #{env['QUERY_STRING']}"]]
  end
  run home
end

map '/login' do
    login = proc do |env|
        authorization_code = orange_api.authorization_code env['QUERY_STRING']
        token = orange_api.get_token authorization_code
        [200, { "Content-Type" => "text/html" }, ["Token data:#{token}"]]
    end
    run login
end

