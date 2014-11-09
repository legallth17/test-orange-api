require 'rest_client'
require 'base64'

RestClient.log = 'stdout'

client_id     = "TXA4vos9G8YM1VGUnFAGU9nTW3fxcgbN"
client_secret = "LAgmZaIGxKvOLHNk"
redirect_uri  = "http%3A%2F%2Fapp1-legallth.rhcloud.com%2Flogin"

authorization_code = "XXXXXXXXXXXXXXXXX"
consumer_key = Base64.encode64(client_id + ":" + client_secret)

token = RestClient.post "https://api.orange.com/oauth/v2/token", "", :Authorization => "Basic #{consumer_key}"
#                          { :grant_type    => "authorization_code",
#                            :code          => authorization_code,
#                            :redirect_uri  => "#{redirect_uri}" },

puts token
