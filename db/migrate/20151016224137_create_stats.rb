class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.integer :user_id
      t.integer :addition
      t.integer :deletion
      t.integer :commits
      t.datetime :week_start_date
      t.integer :repo_id

      t.timestamps null: false
    end
  end
end
