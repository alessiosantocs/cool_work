class CreateEmailAddresses < ActiveRecord::Migration
  def self.up
    create_table :email_addresses do |t|
      t.belongs_to :person
      t.string :email
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :email_addresses
  end
end
