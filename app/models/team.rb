class Team < ActiveRecord::Base
  belongs_to :team_type, :foreign_key => :team_type_id, :class_name => "TeamType"

  def self.get_team_details(team)
    result = {}
    result ={
      "id" => team.id,
      "team_name" => team.name,
      "type" => (team.team_type.name rescue nil),
      "created_at" => team.created_at

    }
    members = []
    user_id = TeamMember.where(:team_id => team.id).pluck(:user_id)
    users  = User.find(user_id)
    info = []
    users.map do |user|
      info << {
      	"user_id" => user.id,
        "name" => user.git_username,
        "profile_image" => user.avatar_url,
        "type" => user.profile.name,
        "profile_url" => user.profile_url
      }
    end
    result["members"] = info
    return result
  end





end
