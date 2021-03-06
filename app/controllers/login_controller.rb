class LoginController < ApplicationController

  def git_callback
    session_code = request.env['rack.request.query_hash']['code']
    site = RestClient::Resource.new('https://github.com/login/oauth/access_token')
    result =         site.post(
      {:client_id => "cffe0ca2e4b88babd27c",
       :client_secret => "1599750bea795965735cbf9391c72f648f6c1327",
       :code => session_code},
    :accept => :json)
    access_token = JSON.parse(result)['access_token']
    redirect_to "http://localhost:4000/github-token/#{access_token}"
  end

  def set_token_in_redis token
    redis = Redis.new
    expires_in = 15.minutes.to_i
    token_data = Hash.new
    expires_at = (Time.now+expires_in.seconds).to_i
    redis.hset("token",key,value)
    redis.expireat(token,expires_at)
  end



end
