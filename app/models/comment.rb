class Comment < ActiveRecord::Base
	belongs_to :user, :class_name => "User"
	belongs_to :pr_info, :class => "PullRequestInfo"
end
