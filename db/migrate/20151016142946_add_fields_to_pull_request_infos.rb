class AddFieldsToPullRequestInfos < ActiveRecord::Migration
  def change
    add_column :pull_request_infos, :repo_id, :integer
  end
end
