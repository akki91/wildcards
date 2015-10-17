class RepoController < ApplicationController

  def index
    repos = Repo.all
    response = {}
    result = Array.new
    repos.map do |repo|
      result <<{
        "id" => repo.id,
        "reponame" => repo.name
      }
      response[:data] = result
    end
    render json: {"result" => response}, status: :o

  end
end
