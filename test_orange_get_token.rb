require 'rest_client'
require 'base64'

RestClient.log = 'stdout'

client_id     = "TXA4vos9G8YM1VGUnFAGU9nTW3fxcgbN"
client_secret = "LAgmZaIGxKvOLHNk"
redirect_uri  = "http://app1-legallth.rhcloud.com/login"

authorization_code = "XXXXXXXXXXXXXXXXX"

token = RestClient::Resource.new('https://api.orange.com/oauth/v2/token', :user => client_id, :password => client_secret)

token.post({ :grant_type    => "authorization_code",
	     :code          => authorization_code,
             :redirect_uri  => "#{redirect_uri}" }) {|response, request, result| 
	puts result.code
	puts response
}

