map '/health' do
  health = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["1"]]
  end
  run health
end

map '/' do
  welcome = proc do |env|
    check_auth_id =  /code=(.*)\?state=ok$/.match(env['QUERY_STRING'])
    if check_auth_id then
       [200, { "Content-Type" => "text/html" }, ["My simple empty app. Authorized id = #{check_auth_id[1]}"]]
    else
       [200, { "Content-Type" => "text/html" }, ["My simple empty app. Authentication is required #{env['QUERY_STRING']}"]]
    end       
  end
  run welcome
end
