class CreateLocation < ActiveRecord::Migration
  def self.up
    create_table "locations" do |t|
      t.column :addr1, :string
      t.column :addr2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string, :limit => 9
      t.column :doorman, :boolean
      t.column :schedule_id, :integer
      t.column :serviced, :boolean
    end
  end

  def self.down
    drop_table "locations"
  end
end
