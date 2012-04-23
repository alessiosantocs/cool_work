class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table "customers" do |t|
      #foreign key for unifying users
      t.column :user_id, :integer
      
      #customer-specific identity information
      t.column :title, :string
      t.column :company, :string
      t.column :sex, :string, :limit => 1
      t.column :dob, :date
      t.column :primary_address_id, :integer
      t.column :work, :string, :limit => 10
      t.column :home, :string, :limit => 10
      t.column :cell, :string, :limit => 10
      
      #customer-specific account information
      t.column :active, :boolean
      t.column :accepted_terms, :boolean
      t.column :points, :integer
      t.column :referrer, :integer
      
      #table meta
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end  
  end

  def self.down
    drop_table "customers"
  end
end
