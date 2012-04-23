class CreateUserAttributes < ActiveRecord::Migration
  def self.up
    create_table :user_attributes do |t|
      t.string :name
      t.belongs_to :User

      t.timestamps
    end
  end

  def self.down
    drop_table :user_attributes
  end
end
