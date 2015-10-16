class AddTeamAndProfileToUser < ActiveRecord::Migration
  def change
     add_column :users, :profile_id, :integer
     add_column :users, :team_id , :integer
  end
end
