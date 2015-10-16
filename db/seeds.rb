# Status.create([{name:"Open"},{name:"Closed"}, {name:"Merged"}])
# PullRequestType.create([{name:"Bug"},{name:"Feature"}])
# Check.create([{name:"Test"},{name:"Documentation"},{name:"QA Passed"},{name:"Code Quality"}])
# Profile.create([{name:"DEVELOPER"},{name:"QA"}])
#TeamType.create([{name:"BAKCEND-DEV"},{name:"BAKCEND-TEST"},{name:"FRONTEND-DEV"},{name:"FRONTEND-TEST"}])


# puts "profiles finished"

# (1..10).each do |no|
# 	Repo.create(name: "repo_#{no}")
# end
# puts "repos finished"

# (1..20).each do |no|
# 	Team.create(name: "team_#{no}",team_type_id: 1)
# end
# puts "teams finished"

# (1..50).each do |no|
#   User.create({
#     "email" => "email_#{no}@housing.com",
#     "git_username" => "username_#{no}",
#     "profile_url" => "https://github.com/kbkailashbagaria",
#     "profile_id" => rand(1..2),
#     "avatar_url" => "https://avatars0.githubusercontent.com/u/4344556?v=3&s=460"
#   })
# end
# puts "users finished"

# (1..100).each do |no|
#   TeamMember.where({
#     "user_id" => rand(1..50),
#     "team_id" => rand(1..20)
#   }).first_or_create
# end
# puts "team_members finished"

# (1..500).each do |no|
#   PullRequestInfo.create({
#     "name" => "team_#{no}",
#     "pr_url" => "https://github.com/loconsolutions/housing-rails/pull/#{no}",
#     "pr_id" => "#{no}",
#     "pr_type_id" => rand(1..2),
#     "author_id" => rand(1..50),
#     "status_id" => rand(1..3),
#     "due_date" => Time.at(((Time.now - 30.days).to_f - Time.now.to_f)*rand + Time.now.to_f),
#     "team_id" => rand(1..20),
#     "merge_time" => rand(1..3)/3 == 0 ? Time.at(((Time.now - 30.days).to_f - Time.now.to_f)*rand + Time.now.to_f) : nil,
#     "deploy_time" => rand(1..3)/3 == 0 ? Time.at(((Time.now - 30.days).to_f - Time.now.to_f)*rand + Time.now.to_f) : nil,
#     "dependent_pr_url" => "https://github.com/loconsolutions/housing-rails/pull/#{rand(1..50)}",
#     "test_url" => "http://kailash.housing.com:3000/prs",
#     "doc_link" => "http://kailash.housing.com:3000/prs",
#     "repo_id" => rand(1..10)
#   })
# end
# puts "prs finished"

# (1..1000).each do |no|
#   Assignee.where({
#     "pr_id" => rand(1..500),
#     "user_id" => rand(1..50)
#   }).first_or_create
# end
# puts "Assignees finished"

# (1..1000).each do |no|
#   PullRequestCheck.where({
#     "pr_id" => rand(1..500),
#     "check_id" => rand(1..4)
#   }).first_or_create
# end
# puts "PullRequestChecks finished"
