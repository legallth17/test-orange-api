require 'net/http'
require 'base64'

client_id     = "TXA4vos9G8YM1VGUnFAGU9nTW3fxcgbN"
client_secret = "LAgmZaIGxKvOLHNk"
redirect_uri  = "http%3A%2F%2Fapp1-legallth.rhcloud.com%2Flogin"

authorization_code = "XXXXXXXXXXXXXXXXX"
consumer_key = Base64.encode64(client_id + ":" + client_secret)

# `curl -X POST -H "Authorization: Basic #{consumer_key}" -d "grant_type=authorization_code&code=#{authorization_code}&redirect_uri=http%3A%2F%2Fapp1-legallth.rhcloud.com%2Flogin" "https://api.orange.com/oauth/v2/token"`

uri  = URI('https://api.orange.com/oauth/v2/token')
post = Net::HTTP::Post.new(uri.path)

# header
post['Authorization'] = "Basic #{consumer_key}"
# parameters
post.set_form_data(:grant_type => "authorization_code", :code => authorization_code, :redirect_uri  => "#{redirect_uri}")

http = Net::HTTP.new(uri.host, uri.port)
http.read_timeout = 1000
http.use_ssl = (uri.scheme == 'https')

res = http.start do |http|
  http.request(post)
end

case res
when Net::HTTPSuccess, Net::HTTPRedirection
  # OK
else
  res.value
end

