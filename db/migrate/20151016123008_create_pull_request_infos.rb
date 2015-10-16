class CreatePullRequestInfos < ActiveRecord::Migration
  def change
    create_table :pull_request_infos do |t|
      t.string :name
      t.string :pr_url
      t.string :pr_id
      t.integer :pr_type_id
      t.integer :assigned_id
      t.integer :author_id
      t.integer :status_id
      t.string :remote
      t.datetime :due_date
      t.integer :team_id
      t.boolean :is_mergeable
      t.datetime :merge_time
      t.datetime :deploy_time

      t.timestamps null: false
    end
  end
end
