class Stat < ActiveRecord::Base
  belongs_to :user

  def self.make_request path
    access_token = ''
    authorization_header = 'token ' + access_token
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => authorization_header
    }
    uri = URI.parse("https://api.github.com")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.get(path, headers)
    return response
  end

  def self.fetch_prs page=1
    path = "/repos/loconsolutions/housing.notifications/pulls?page=#{page}&state=all&sort=updated&direction=desc"
    repo_id = Repo.where(name: "housing.notifications").first_or_create.id
    response = make_request(path)
    if response.code == "200" && !((JSON.parse(response.read_body)).empty?)
      JSON.parse(response.read_body).each do |data|
        author_id = User.where(git_username: data["user"]["login"]).first_or_create.id
        status_id = Status.where("lower(name) = ?", data["state"].downcase).first.id
        PullRequestInfo.create({
          "name" => data["title"],
          "pr_url" => data["html_url"],
          "pr_id" => data["number"],
          "author_id" => author_id,
          "status_id" => status_id,
          "merge_time" => data["merged_at"],
          "repo_id" => repo_id,
          "sha" => data["head"]["sha"]
        })
      end
      fetch_prs(page+1)
    else
      puts "#{response.code} \n"
      puts "#{JSON.parse(response.read_body)} \n"
    end
  end

  
  def self.fetch_all_repo_stats
    Repo.all.each do |repo|
      fetch_stats(repo)
    end
  end
  
  def self.fetch_stats page=1, repo
      path = "/repos/loconsolutions/#{repo.name}/stats/contributors?page=#{page}"
      response = make_request(path)
      if response.code == "200" && !((JSON.parse(response.read_body)).empty?)
        JSON.parse(response.read_body).each do |data|
          git_username = data["author"]["login"]
          user = User.where(git_username: git_username).first_or_initialize
          user.profile_url = data["author"]["url"]
          user.avatar_url = data["author"]["avatar_url"]
          user.save

          data["weeks"].each do |weekly_data|
            stat = Stat.where(user_id: user.id, repo_id: repo.id, week_start_date: Time.at(weekly_data["w"])).first_or_initialize
            stat.addition = weekly_data["a"]
            stat.deletion = weekly_data["d"]
            stat.commits = weekly_data["c"]
            stat.save
          end
        end
        fetch_stats(page+1, repo)
      else
        puts "#{response.code} \n"
      end
  end

  def self.fetch_all_repos page=1
    path = "/orgs/loconsolutions/repos?page=#{page}"
    response = make_request(path)
    if response.code == "200" && !((JSON.parse(response.read_body).map{|a| a["name"]}).empty?)
      repos = JSON.parse(response.read_body).map{|a| a["name"]}
      repos.each do |repo_name|
        Repo.where(name: repo_name).first_or_create
      end
      fetch_all_repos(page+1)
    else
      puts "#{response.code} \n"
      puts "#{JSON.parse(response.read_body).map{|a| a["name"]}}"
    end
  end
end
