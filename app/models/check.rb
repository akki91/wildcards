class Check < ActiveRecord::Base
  has_many  :pull_request_checks, :class_name => "::PullRequestCheck"
  has_many  :pull_request_infos, :through => :pull_request_checks, :class_name => "::PullRequestInfo"
end
