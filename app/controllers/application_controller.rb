class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :validate_token

  def validate_token
    token
    uri = URI.parse("https://api.github.com?access_token=#{@token}")                                                                                                             │······················
    http = Net::HTTP.new(uri.host, uri.port)                                                                                                              │······················
    http.use_ssl = true                                                                                                                                   │······················
    response = http.get(path, headers)
  	if response.code != 200
  		render :json => {:message => @message,:unauthorized => true}, status: :unauthorized
  	end
  end

  private
  def token
    @token = params[:auth_token]
  end

end


