class Comment < ActiveRecord::Base
	belongs_to :user, :foreign_key => "user_id", :class_name => "User"
	belongs_to :pr_info, :foreign_key => "pr_info_id",  :class_name => "PullRequestInfo"
end
