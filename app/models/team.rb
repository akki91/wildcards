class Team < ActiveRecord::Base
  belongs_to :team_type, :foreign_key => :team_type_id, :class_name => "TeamType"
end
