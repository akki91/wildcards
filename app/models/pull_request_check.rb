class PullRequestCheck < ActiveRecord::Base
	belongs_to :check
	belongs_to :pr, :class_name => "PullRequestInfo"
end
