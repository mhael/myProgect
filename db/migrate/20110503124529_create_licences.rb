class CreateLicences < ActiveRecord::Migration
  def self.up
    create_table :licences do |t|
      t.string :name
      t.string :town
      t.string :link
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :licences
  end
end
