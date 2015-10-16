class PrsController < ApplicationController

  protect_from_forgery with: :null_session

  # Filters: repository, status, type, participant
  # group_by: repository
  # sort_by: due_date
  def index
    response = PullRequestInfo.filtered_prs(params)
    render json: response, status: 200
  end

  def update
    render json: {}, status: 200
  end

end
