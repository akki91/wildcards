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
    stats = Stat.joins(:user).where("users.git_username = ?", params[:u])
                .order(:week_start_date)
                .group(:week_start_date)
                .select("week_start_date, SUM(addition) as addition, SUM(deletion) as deletion, SUM(commits) as commits")
    @additions = stats.map{|a| [a.week_start_date.to_i, a.addition]}
    @deletions = stats.map{|a| [a.week_start_date.to_i, a.deletion]}
    @commits = stats.map{|a| [a.week_start_date.to_i, a.commits]}
    render json: {"additions" => @additions, "deletions" => @deletions, "commits" => @commits}, status: :ok
    # render :stats
  end

end
