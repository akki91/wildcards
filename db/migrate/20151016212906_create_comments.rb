class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :pr_info_id
      t.string :comment_id
      t.text :body
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
