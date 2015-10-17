class TeamsController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    teams = Team.all
    response = Hash.new
    responses = Array.new
    teams.each do |team|
      details = Team.get_team_details(team)
      responses << details
    end
    result = {}
    result[:data] = responses
    render json: result, status: :ok
  end

  def create
    t = Team.new
    t.name = params[:team_name]
    t.team_type_id = params[:type]
    if t.save
      render json: {"message"=>"Success"}, status: 200
    else
      render json: {"message"=>"Unable to create team"}, status: 400
    end
  end

  def update
    team_id = params[:id]
    user_id =params[:user_id]
    if params[:action]  == 'add'
      TeamMember.create(:team_id=>team_id,:user_id=>user_id)
      render json: {"message"=>"Success"}, status: 200
    else
      TeamMember.where(:team_id=>team_id,:user_id=>user_id).first.destroy
      render json: {"message"=>"Success"}, status: 200
    end
  end

  def autocomplete
    keyword = "#{params["team_name"].upcase}%" rescue nil
    if keyword
      team_auto_search = Team.where("UPPER(teams.name) LIKE ?",keyword).limit(20).select(["teams.id as id, teams.name as name"])
      render json: {"result" => team_auto_search}, status: :ok
    else
      render json: {"message" => "No Querying Parameter provided"}, status: :unprocessable_entity
    end
  end

  def auto_suggest_reviewer
    pr = PullRequestInfo.find_by_id(params[:id])
    if pr
      team_members = TeamMember.where(id: pr.team_id).pluck("id") if pr.team_id
      open_status_id = Status.find_by_name("Open").id
      result = PullRequestInfo.where(:team_id => pr.team_id, :status_id => open_status_id).where('created_at >= ?', Time.now-5.days).joins(:assignees).where("assignees.user_id" => team_members).group(:user_id).order('count_id ASC').count('id')
      response = []
      (result || {}).each do |key, value|
        res = {}
        res["id"] = key
        res["name"] = User.find_by_id(key).git_username 
        response.push(res)
      end
      render json: {"response" => response.in_groups(3, false).first}, status: 200

    else
      render json: {"message"=>"Unable to suggest"}, status: 400
    end

  end

  def delete_team
    team = Team.find_by_id(params[:team_id])
    Team.delete(team) if team
    render json: {"message" => "Success"}, status: 200
  end

  def update_team
    team = Team.find_by_id(params[:team_id])
    Team.update(team.id, :name => params[:name], :team_type_id => params[:team_type_id])
    render json: {"message" => "Success"}, status: 200
  end


end
