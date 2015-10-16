class UsersController < ApplicationController

  protect_from_forgery with: :null_session

  def show
    render json: {}, status: 200
  end

  def autocomplete
    render json: {}, status: 200
  end

end
