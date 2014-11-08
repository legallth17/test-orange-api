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
    client_id   = "TXA4vos9G8YM1VGUnFAGU9nTW3fxcgbN"
    authent_url = "https://api.orange.com/oauth/v2/authorize?scope=openid&response_type=code&client_id=#{client_id}&state=ok&redirect_uri=http%3A%2F%2Fapp1-legallth.rhcloud.com%2F%login"
       [301, { "Location" => authent_url }, ["My simple empty app. Authentication is required #{env['QUERY_STRING']}"]]
  end
  run welcome
end

map '/login' do
  welcome = proc do |env|
    check_auth_id =  /code=(.*)\&state=ok$/.match(env['QUERY_STRING'])
    if check_auth_id then
       [200, { "Content-Type" => "text/html" }, ["Authorized id = #{check_auth_id[1]}"]]
    else
       [200, { "Content-Type" => "text/html" }, ["Authorization failed"]]
    end       
  end
  run welcome
end
# https://api.orange.com/oauth/v2/authorize?scope=openid&response_type=code&client_id=6lkqGtxO0Cipb1aEVaAdEsglVkiSutwL&prompt=login%20consent&state=ok&redirect_uri=http%3A%2F%2Fapp1-legallth.rhcloud.com
