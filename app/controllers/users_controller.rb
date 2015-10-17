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

  def index
    users = User.all
    response = {}
    result = Array.new
    users.map do |user|
    result <<{
        "id" => user.id,
        "username" => user.git_username
      }
    response[:data] = result
    end
    render json: {"result" => response}, status: :ok

  end


  def stats
    stats = Stat.where(user_id: 53).order(:week_start_date).select("week_start_date, addition, deletion, commits")
    @weeks = stats.collect(&:week_start_date).map{|a| a.year}
    @additions = stats.collect(&:addition)
    @deletions = stats.collect(&:deletion)
    @commits = stats.collect(&:commits)
    render :stats
  end

end
