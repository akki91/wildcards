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

  def merge_pr
    uri = URI.parse("https://api.github.com/repos/#{self.author.git_username}/#{self.repo.name}/pulls/#{self.pr_id}/merge")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    payload = {"commit_message" => "merging", "sha" => self.sha}
    req.body = payload.to_json
    req["Authorization"] ="64e15773a30686ff0f655cf3184086beb3f11dd1"
    req["Content-Type"] = "application/json"
    response = http.request(req)
  end

end
