class RemoveColumns < ActiveRecord::Migration
  def change
    remove_column :pull_request_infos, :assigned_id, :integer
    remove_column :pull_request_infos, :is_mergeable, :integer
  end
end
