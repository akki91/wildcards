class Addinfotousers < ActiveRecord::Migration
  def change
  	add_column :users, :profile_image, :string
  	add_column :users, :profile_url, :string
  end
end
