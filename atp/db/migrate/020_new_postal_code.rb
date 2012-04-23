require 'faster_csv'

class NewPostalCode < ActiveRecord::Migration
  def self.up
    drop_table "postal_codes"
    create_table "postal_codes" do |t|
        t.column :ZIPCode, :string, :limit => 5
        t.column :ZIPType, :string, :limit => 1
        t.column :CityName, :string, :limit => 64
        t.column :CityType, :string, :limit => 1
        t.column :CountyName, :string, :limit => 64
        t.column :CountyFIPS, :string, :limit => 5
        t.column :StateName, :string, :limit => 64
        t.column :StateAbbr, :string, :limit => 2
        t.column :StateFIPS, :string, :limit => 2
        t.column :MSACode, :string, :limit => 4
        t.column :AreaCode, :string, :limit => 16
        t.column :TimeZone, :string, :limit => 16
        t.column :UTC, :float
        t.column :DST, :string, :limit => 1
        t.column :Latitude, :float
        t.column :Longitude, :float
    end
    file = './db/postal_codes.txt'
    FasterCSV.foreach(file, :headers => true ){|r| PostalCode.create(r.to_hash) }
    add_index :postal_codes, [:ZipCode, :CityType], :name => "zip_prim"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end