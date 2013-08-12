class FixColumnType < ActiveRecord::Migration
  def change
	change_column :microposts, :content, :text
  end
end
