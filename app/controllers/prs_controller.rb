class PrsController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    render json: {}, status: 200
  end

  def update
    render json: {}, status: 200
  end

end
