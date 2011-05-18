class AddLinkToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :link, :string
    add_index :users, :link,                :unique => true
  end

  def self.down
    remove_column :users, :link
  end
end
