class AddShaToPrInfo < ActiveRecord::Migration
  def change
  	add_column :pull_request_infos, :sha, :string
  end
end
