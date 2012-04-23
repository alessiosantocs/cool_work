class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :url
      t.date :founded
      t.integer :employee_number
      t.string :market_segment
      t.text :description
      t.text :private_notes
      t.boolean :enabled

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
