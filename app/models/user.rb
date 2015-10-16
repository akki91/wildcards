class User < ActiveRecord::Base
  belongs_to :team
  belongs_to :profile, :foreign_key => :profile_id, :class_name => "Profile"
end
