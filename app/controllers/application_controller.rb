class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :validate_token

  def validate_token
    token
    url = URI.encode("https://api.github.com?access_token=#{@token}")
    url = URI.parse(url)
    response = Net::HTTP.get_response(url)
      if response.code != "200"
      	render :json => {:message => @message,:unauthorized => true}, status: :unauthorized
      end
   end

  private
  def token
    @token = params[:auth_token]
  end

end
