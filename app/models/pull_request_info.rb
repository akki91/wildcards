class PullRequestInfo < ActiveRecord::Base
  belongs_to :status
  belongs_to :repo
  belongs_to :type
  belongs_to :pull_request_type, foreign_key: "pr_type_id"
  belongs_to :author, :class_name => "User"
  
  has_many :assignees

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
      pr["checks"] = checks_superset.map{ |check|
        check => pr_checks[pr.id].include?(check)
      }
      pr["participants"] = pr_participants[pr.id]
      pr["author"] = {
        "name" => pr["author_name"],
        "profile_image" => pr["author_profile_image"],
        "profile_url" => pr["author_profile_url"],
        "type" => pr["author_type"]
      }
      pr.delete("author_name")
      pr.delete("author_profile_image")
      pr.delete("author_profile_url")
      pr.delete("author_type")
    end   
  end

  def self.collect_prs filters
    prs = self.class.joins(:status)
              .joins(:repo)
              .joins(:type)
              .joins(:pull_request_type)
              .joins("INNER JOIN users as author on author.id = pull_request_infos.author_id")
              .joins("INNER JOIN profiles on profiles.id = author.profile_id")
              .select("DISTINCT ON (pull_request_infos.id) pull_request_infos.id,
                pull_request_infos.name as title,
                statuses.name as status,
                pull_request_types.name as type,
                pull_request_infos.test_url as testing_url,
                pull_request_infos.doc_link as documentation_url,
                pull_request_infos.updated_at as last_updated,
                pull_request_infos.pr_url,
                repos.name as repo,
                author.name as author_name,
                author.profile_image as author_profile_image,
                author.avatar_url as author_profile_url,
                profiles.name as author_type
              ")
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
            .select("assignees.pr_id, users.name, users.avatar_url as profile_url, users.profile_image, profiles.name as type")
            .each do |assignee|
              pr_participants[assignee.pr_id].push({
                "name" => assignee.name,
                "profile_image" => assignee.profile_image,
                "profile_url" => assignee.profile_url,
                "type" => assignee.type
                })
            end
    return pr_participants
  end

end
