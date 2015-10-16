class TeamsController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    teams = Team.all
   # debugger
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
    render json: {}, status: 200
  end

  def update
    render json: {}, status: 200
  end

  def autocomplete
    render json: {}, status: 200
  end

end
