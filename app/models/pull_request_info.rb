class PullRequestInfo < ActiveRecord::Base
  belongs_to :status
  belongs_to :repo, foreign_key: "repo_id"
  belongs_to :pull_request_type, foreign_key: "pr_type_id"
  belongs_to :author, :class_name => "User"
  
  has_many :assignees, foreign_key: "pr_id"

  # Filters: repository, status, type, participant
  # group_by: repository
  # sort_by: due_date
  def self.filtered_prs filters
    
    prs = collect_prs(filters)
    pr_checks = collect_checks(prs.collect(&:id))
    pr_participants = collect_participants(prs.collect(&:id))
    checks_superset = Check.pluck(:name)

    response = Hash.new
    response["repos"] = Repo.pluck(:name)
    response["pull_requests"] = prs.map do |pr|
      pr["last_updated"] = pr["last_updated"].to_i
      pr["pr_due_date"] = pr["pr_due_date"].to_i
      pr["checks"] = checks_superset.map{ |check|
        {check => pr_checks[pr.id].include?(check)}
      }
      pr["participants"] = pr_participants[pr.id]
      # pr["author"] = {
      #   "name" => pr["author_name"],
      #   "profile_image" => pr["author_profile_image"],
      #   "profile_url" => pr["author_profile_url"],
      #   "type" => pr["author_type"]
      # }
      pr
    end
    response   
  end
  
  # Filters: repository, status, type, participant
  # group_by: repository
  # sort_by: due_date
  def self.collect_prs filters
    prs = self.joins(:status)
              .joins(:repo)
              .joins(:pull_request_type)
              .joins("INNER JOIN users as author on author.id = pull_request_infos.author_id")
              .joins("INNER JOIN profiles on profiles.id = author.profile_id")
              .select("pull_request_infos.id,
                pull_request_infos.name as title,
                statuses.name as pr_status,
                pull_request_types.name as pr_type,
                pull_request_infos.test_url as testing_url,
                pull_request_infos.doc_link as documentation_url,
                pull_request_infos.updated_at as last_updated,
                pull_request_infos.due_date as pr_due_date,
                pull_request_infos.pr_url,
                repos.id as repo_id,
                repos.name as repo_name,
                author.id as author_id,
                author.git_username as author_name,
                author.avatar_url as author_profile_image,
                author.profile_url as author_profile_url,
                profiles.name as author_type,
                '' as checks,
                '' as participants
              ")
    if filters["repository"]
      prs = prs.where("lower(repos.name) = ?", filters["repository"].downcase)
    end
    if filters["status"]
      prs = prs.where("lower(statuses.name) = ?", filters["status"].downcase)
    end
    if filters["type"]
      prs = prs.where("lower(pull_request_types.name) = ?", filters["type"].downcase)
    end
    if filters["participant"]
      # prs = prs.joins(:assignees).where("assignees.user_id = ? OR author.id = ?", filters["participant"], filters["participant"])
      prs = prs.where("pull_request_infos.id IN (?) OR author.id = ?", Assignee.where(user_id: filters["participant"]).collect(&:pr_id), filters["participant"])
    end
    if filters["sort_by"] && filters["sort_by"] == "due_date"
      prs = prs.order("pull_request_infos.due_date")
    else
      prs = prs.order("pull_request_infos.repo_id")
    end
    if filters["query"]
      prs = prs.where("lower(pull_request_infos.name) LIKE ? ", "%#{filters["query"].downcase}%")
    end

    prs
  end


  def self.collect_checks pr_ids
    pr_checks = Hash.new { |hash, key| hash[key] = [] }
    PullRequestCheck.joins(:check)
                    .where(pr_id: pr_ids)
                    .select("pull_request_checks.pr_id, checks.name")
                    .each do |pr_check|
                      pr_checks[pr_check.pr_id].push(pr_check.name)
                    end
    return pr_checks
  end

  def self.collect_participants pr_ids
    pr_participants = Hash.new { |hash, key| hash[key] = [] }
    Assignee.joins(user: :profile)
            .where(pr_id: pr_ids)
            .select("assignees.pr_id, users.id, users.git_username as name, users.avatar_url as profile_image, users.profile_url, profiles.name as type")
            .each do |assignee|
              pr_participants[assignee.pr_id].push({
                "id" => assignee.id,
                "name" => assignee.name,
                "profile_image" => assignee.profile_image,
                "profile_url" => assignee.profile_url,
                "type" => assignee.type
                })
            end
    return pr_participants
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

  def self.test_merge_pr
    # url = URI.parse("https://api.github.com/repos/hemantmundra/wildcards/pulls/46/merge?access_token=64e15773a30686ff0f655cf3184086beb3f11dd1")
    # req = Net::HTTP::Post.new(url.request_uri)
    # req["Authorization"] ="64e15773a30686ff0f655cf3184086beb3f11dd1"
    # req["Content-Type"] = "application/json"
    # req.set_form_data('commit_message' => 'merging', 'sha' => '4dfa63eb0fdfdab86120120545d9da3443dc9c3a', 'access_token' => '64e15773a30686ff0f655cf3184086beb3f11dd1')
    # http = Net::HTTP.new(url.host, url.port)
    # http.use_ssl = (url.scheme == "https")
    # response = http.request(req)

    uri = URI.parse("https://api.github.com/repos/hemantmundra/wildcards/pulls/46/merge")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    payload = {"commit_message" => "merging", "sha" => "4dfa63eb0fdfdab86120120545d9da3443dc9c3a"}
    req.body = payload.to_json
    req["Authorization"] ="64e15773a30686ff0f655cf3184086beb3f11dd1"
    req["Content-Type"] = "application/json"
    response = http.request(req)
  end

end
