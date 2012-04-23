class CreatePhoneNumbers < ActiveRecord::Migration
  def self.up
    create_table :phone_numbers do |t|
      t.belongs_to :person
      t.string :phone
      t.string :type

      t.timestamps
    end
  end

  def self.down
    drop_table :phone_numbers
  end
end
