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
    t.name = params = params[:team_name]
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

end
