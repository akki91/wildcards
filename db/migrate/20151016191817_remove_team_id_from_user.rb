class RemoveTeamIdFromUser < ActiveRecord::Migration
  def change
  	remove_column :users, :team_id, :integer
  end
end
