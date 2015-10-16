class CreateTeamTypes < ActiveRecord::Migration
  def change
    create_table :team_types do |t|

      t.timestamps null: false
    end
  end
end
