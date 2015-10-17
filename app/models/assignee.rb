class Assignee < ActiveRecord::Base
  belongs_to :user
  belongs_to :pr, :class_name => "PullRequestInfo"
end
