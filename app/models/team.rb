class Team < ActiveRecord::Base
  belongs_to :team_type, :foreign_key => :team_type_id, :class_name => "TeamType"

  def self.get_team_details(team)
  	result = {}
  	result ={
  		"team_name" => team.name,
  		"type" => team.team_type.name,
  		"created_at" => team.created_at

  	}
   	members = []
   	user_id = TeamMember.where(:id => team.id).pluck(:user_id)
   	users  = User.find(user_id)
   	info = {}
   	users.map do |user|
   	info = { 
   		"name" => user.git_username,
   		"profile_url" => user.avatar_url,
   		"type" => user.profile.name
   	}
   end
   result[:member] = info
   return result
  end
end
