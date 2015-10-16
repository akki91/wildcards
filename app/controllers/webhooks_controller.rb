class WebhooksController < ApplicationController

  protect_from_forgery with: :null_session

  def create
    # debugger


    status = params["action"]
    checks = params["pull_request"]["title"]
    pr_url = params["pull_request"]["url"]
    pr_id = params["pull_request"]["id"]
    if (params["pull_request"]["feature"] == "Bug" rescue nil)
      pr_type_id = 1
    elsif (params["pull_request"]["feature"] == "Feature" rescue nil)
      pr_type_id = 2
    end
    name = params["pull_request"]["title"]["name"] rescue nil
    user = params["pull_request"]["user"]["login"]
    author = params["pull_request"]["sender"]["login"]
    assignee = nil
    is_mergeable = false
    debugger

    PullRequestInfo.create({:name => name, :pr_url => pr_url, :pr_id => pr_id, :pr_type_id => pr_type_id, :author_id => 5, :is_mergeable => is_mergeable})

    # render json: {}, status: 200
  end
end
