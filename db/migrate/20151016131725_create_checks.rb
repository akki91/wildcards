class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
