class LoginController < ApplicationController

  def git_callback
    session_code = request.env['rack.request.query_hash']['code']
    site = RestClient::Resource.new('https://github.com/login/oauth/access_token')
    	result = 		     site.post(
                             {:client_id => "cffe0ca2e4b88babd27c",
                              :client_secret => "1599750bea795965735cbf9391c72f648f6c1327",
                              :code => session_code},
                              :accept => :json)

    # extract the token and granted scopes
    access_token = JSON.parse(result)['access_token']
    set_login_cookies access_token
    render json: {:message => "Authentication Success"}, :status => 200 
  end

  def set_login_cookies val
    if root_url.start_with?("https")
      cookies.permanent[:github_token] = {value: val, domain: '.housing.com', httponly: true, secure: true}
    else
      cookies.permanent[:github_token] = {value: val, domain: '.housing.com', httponly: true, secure: false}
    end
  end


end
