class CreatePullRequestTypes < ActiveRecord::Migration
  def change
    create_table :pull_request_types do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
