class CreatePullRequestChecks < ActiveRecord::Migration
  def change
    create_table :pull_request_checks do |t|
      t.integer :pr_id
      t.integer :check_id
    end
  end
end
