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
    pr = PullRequestInfo.find(params[:id])
    pr.update(params)
    render json: {}, status: 200
  end

  def update_pr_status
    pr = PullRequestInfo.find(params[:id])
    pr.status_id = Status.where(name:"Closed").first.id
    merge_response = pr.merge_pr
    if merge_response.code == "200" && pr.save
      render json: {}, status: 200
    elsif merge_response.code != "200"
      render json: {errors: merge_response.body}, status: 422
    else
      render json: pr.errors.messages, status: 422
    end
  end

end
