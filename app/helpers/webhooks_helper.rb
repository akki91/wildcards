module WebhooksHelper

  def handle_event params, event
    case event
    when "pull_request"
      pull_request_event params
    when "issue_comment"
      issue_comment_event params
    when "pull_request_review_comment"
      pull_request_review_comment params
    end 
  end

  def commit_comment_event
  end

  def create_event
    
  end

  def delete_event
  end

  def issue_comment_event params
    comment_id = params["comment"]["id"] rescue nil
    comment = params["comment"]["body"] rescue nil
    pr_url = (params["comment"]["html_url"].partition("#").first rescue nil) if comment_id
    user_id = (User.find_by_git_username(params["sender"]["login"]).id rescue 1)
    if pr_url
      pr_info_id = PullRequestInfo.find_by_pr_url(pr_url).id rescue nil
      Comment.create({pr_info_id: pr_info_id, comment_id: comment_id, body: comment, user_id: user_id}) if pr_info_id
      PullRequestInfo.update(pr_info_id, :updated_at => Time.now) if pr_info_id
    end
  end

  def issue_event

  end

  def pull_request_event params
    pr_url = params["pull_request"]["html_url"] 
    pr_id = params["pull_request"]["id"]
    pr_type = params["pull_request"]["title"]["pr_type"].downcase.capitalize rescue 2
    test_url = params["pull_request"]["title"]["test_url"] rescue nil 
    doc_link = params["pull_request"]["title"]["doc_link"] rescue nil 
    pr_type_id  = (PullRequestType.find_by_name(pr_type).id rescue nil) 
    name = params["pull_request"]["title"]
    assignee = params["pull_request"]["assignee"]
    puts "assignee: #{assignee}"
    assignee_id = 1
    author_github_login = params["sender"]["login"] 
    author_id = (User.find_by_git_username(author_github_login).id rescue nil) if author_github_login
    repo_name = params["repository"]["full_name"]
    repo_id = (Repo.find_by_name(repo_name).id rescue nil) if repo_name 
    sha = params["pull_request"]["head"]["sha"]
    case params["pull_request"]["state"]
    when "open"
      pr = PullRequestInfo.find_by_pr_id(pr_id)
      status_id = Status.find_by_name("Open").id
      if pr
        pr.update(:status_id => 1, :sha => sha)
      else
        PullRequestInfo.create({pr_url: pr_url, pr_id: pr_id, pr_type_id: pr_type_id, author_id: author_id, status_id: status_id, repo_id: repo_id, sha: sha, test_url: test_url, doc_link: doc_link})
      end

    when "closed"
      pr = PullRequestInfo.find_by_pr_id(pr_id)
      if params["pull_request"]["merged"]
        if pr
          status_id = Status.find_by_name("Merged").id
          pr.update(:merge_time => Time.now, status_id: status_id)
        end
      else
        status_id = Status.find_by_name("Closed").id
        pr.update(status_id: status_id) if pr 
      end
    # when "assigned"

    # when "unassigned"

    # when "labeled"

    # when "unlabeled"

    # when "reopened"
        
    # when "synchronize"
 
        
    end
  end

  def pull_request_review_comment params
    comment_id = params["comment"]["id"] rescue nil
    comment = params["comment"]["body"] rescue nil
    pr_url = (params["comment"]["html_url"].partition("#").first rescue nil) if comment_id
    user_id = (User.find_by_git_username(params["sender"]["login"]).id rescue 1)
    if pr_url
      pr_info_id = PullRequestInfo.find_by_pr_url(pr_url).id rescue nil
      Comment.create({pr_info_id: pr_info_id, comment_id: comment_id, body: comment, user_id: user_id}) if pr_info_id
      PullRequestInfo.update(pr_info_id, :updated_at => Time.now) if pr_info_id
    end
  end

  def push_event
  end

  def repository_event
  end

  def team_add_event
  end


end