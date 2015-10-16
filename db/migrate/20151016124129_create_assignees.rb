class CreateAssignees < ActiveRecord::Migration
  def change
    create_table :assignees do |t|
      t.integer :pr_id
      t.integer :user_id
    end
  end
end
