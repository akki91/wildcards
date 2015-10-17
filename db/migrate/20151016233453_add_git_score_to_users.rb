class AddGitScoreToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :git_score, :integer
  end
end
