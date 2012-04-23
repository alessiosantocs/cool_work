class CreateAddress < ActiveRecord::Migration
  def self.up
    create_table "addresses" do |t|
      t.column :label, :string, :limit => 20
      t.column :location_id, :integer
      t.column :customer_id, :integer
      t.column :unit_designation, :string, :limit => 12
      t.column :unit_number, :string, :limit => 8
    end
  end

  def self.down
    drop_table "addresses"
  end
end