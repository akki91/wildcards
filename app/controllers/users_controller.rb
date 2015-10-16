class UsersController < ApplicationController

  protect_from_forgery with: :null_session

  def show
    render json: {}, status: 200
  end

  def autocomplete
    keyword = "#{params["git_name"].upcase}%" rescue nil 
    if keyword
      users_auto_search = User.where("UPPER(users.git_username) LIKE ?",keyword).limit(5).select(["users.id as id, users.email as email,users.git_username as username,users.avatar_url as avatar_url"])
      render json: {"result" => users_auto_search}, status: :ok
    else
      render json: {"message" => "No Querying Parameter provided"}, status: :unprocessable_entity
    end

  end

end
