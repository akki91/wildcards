class Stat < ActiveRecord::Base

  def self.make_request path
    access_token = '6d2e9aef9931d83abf93b7e8c10230d4cb38d92e'
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
  
  def self.fetch_stats
    Repo.all.each do |repo|
      path = "/repos/loconsolutions/#{repo.name}/stats/contributors"
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
      else
        puts "#{response.code} \n"
      end
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




{"total"=>1, "weeks"=>[{"w"=>1400371200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1400976000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1401580800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1402185600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1402790400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1403395200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1404000000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1404604800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1405209600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1405814400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1406419200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1407024000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1407628800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1408233600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1408838400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1409443200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1410048000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1410652800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1411257600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1411862400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1412467200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1413072000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1413676800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1414281600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1414886400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1415491200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1416096000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1416700800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1417305600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1417910400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1418515200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1419120000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1419724800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1420329600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1420934400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1421539200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1422144000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1422748800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1423353600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1423958400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1424563200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1425168000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1425772800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1426377600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1426982400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1427587200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1428192000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1428796800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1429401600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1430006400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1430611200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1431216000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1431820800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1432425600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1433030400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1433635200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1434240000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1434844800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1435449600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1436054400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1436659200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1437264000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1437868800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1438473600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1439078400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1439683200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1440288000, "a"=>19, "d"=>1, "c"=>1}, {"w"=>1440892800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1441497600, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1442102400, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1442707200, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1443312000, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1443916800, "a"=>0, "d"=>0, "c"=>0}, {"w"=>1444521600, "a"=>0, "d"=>0, "c"=>0}], 

"author"=>{"login"=>"gupta2007vaibhav", "id"=>4046359, "avatar_url"=>"https://avatars.githubusercontent.com/u/4046359?v=3", "gravatar_id"=>"", "url"=>"https://api.github.com/users/gupta2007vaibhav", "html_url"=>"https://github.com/gupta2007vaibhav", "followers_url"=>"https://api.github.com/users/gupta2007vaibhav/followers", "following_url"=>"https://api.github.com/users/gupta2007vaibhav/following{/other_user}", "gists_url"=>"https://api.github.com/users/gupta2007vaibhav/gists{/gist_id}", "starred_url"=>"https://api.github.com/users/gupta2007vaibhav/starred{/owner}{/repo}", "subscriptions_url"=>"https://api.github.com/users/gupta2007vaibhav/subscriptions", "organizations_url"=>"https://api.github.com/users/gupta2007vaibhav/orgs", "repos_url"=>"https://api.github.com/users/gupta2007vaibhav/repos", "events_url"=>"https://api.github.com/users/gupta2007vaibhav/events{/privacy}", "received_events_url"=>"https://api.github.com/users/gupta2007vaibhav/received_events", "type"=>"User", "site_admin"=>false}}
