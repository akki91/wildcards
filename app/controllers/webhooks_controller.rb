class WebhooksController < ApplicationController
  include WebhooksHelper

  protect_from_forgery with: :null_session

  def create
    # puts "X-GitHub-Delivery:  #{request.headers['X-GitHub-Delivery']}"
    # puts "X-GitHub-Event: #{request.headers['X-GitHub-Event']}"
    event = request.headers['X-GitHub-Event']
    handle_event(params, event)
    
    render json: {}, status: 200
  end
end
