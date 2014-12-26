require 'cgi'
require 'rest_client'
require 'json'
require 'base64url'

RestClient.log = 'stdout'

class OrangeApi
	attr_accessor :client_id, :client_secret, :redirect_uri

	def check_client_id
		raise ArgumentError, "client_id is not defined" if @client_id == nil
	end

	def check_client_secret
		raise ArgumentError, "client_secret is not defined" if @client_secret == nil
	end

	def check_redirect_uri
		raise ArgumentError, "redirect_uri is not defined" if @redirect_uri == nil
	end

	def authent_url
		check_client_id
		check_redirect_uri
		"https://api.orange.com/oauth/v2/authorize?scope=openid%20profile&prompt=login&response_type=code&client_id=#{@client_id}&state=ok&redirect_uri=#{CGI.escape(@redirect_uri)}"
	end

	def authorization_status(query_string)
		authorization = {}
        # code=xxxxxx&state=ok
        check_auth_code =  /code=(.*)\&state=ok$/.match(query_string)
        if check_auth_code then
        	authorization[:code] = check_auth_code[1]
        	return authorization
        end
		# error=access_denied&error_description=consent denied&state=ok
        check_auth_error =  /error=(.*)\&error_description=(.*)\&state=ok$/.match(query_string)
        if check_auth_error then
        	authorization[:error] = check_auth_error[1]
        	authorization[:error_description] = check_auth_error[2]
        	return authorization
        end
        {:error => "no_authorization_code", :error_description => "unable to extract code from query string #{query_string}"}
	end

	def authorization_code(query_string)
        check_auth_id =  /code=(.*)\&state=ok$/.match(query_string)
        return nil unless check_auth_id
        check_auth_id[1]
	end

	def get_token(authorization_code)
		check_client_id
		check_client_secret
		check_redirect_uri
        token = nil
        newToken = RestClient::Resource.new('https://api.orange.com/oauth/v2/token', :user => @client_id, :password => @client_secret)
        newToken.post({ :grant_type => "authorization_code", :code => authorization_code, :redirect_uri  => "#{redirect_uri}" }) do |response, request, result| 
			raise StandardError, "Unable to get token: #{response}" if response.code != 200        	
            token = JSON.parse(response.body)
        end
        token
	end

	def access_token(token)
        token['access_token']
	end

	def id_token(token)
       	# decode id_token which contains user id
      	encoded_id_token = token['id_token'].split('.')[1]
		JSON.parse(Base64URL.decode(encoded_id_token))
	end

	def get_user_data(token)
		RestClient.get('https://api.orange.com/openidconnect/v1/userinfo/',{ 'Authorization' => "Bearer #{token['access_token']}" })
	end

end
