class AddMoreFieldsToPullRequestInfo < ActiveRecord::Migration
  def change
    add_column :pull_request_infos, :dependent_pr_url, :string
    add_column :pull_request_infos, :test_url, :string
    add_column :pull_request_infos, :doc_link, :string
    remove_column :pull_request_infos, :remote, :string
  end
end
