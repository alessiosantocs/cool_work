class CreateServiceClasses < ActiveRecord::Migration
  def self.up
    create_table "services" do |t|
      t.column :name, :string
      t.column :description, :text
    end
    create_table "serviced_zips" do |t|
      t.column :zip, :string, :limit => 9
    end
    create_table "prices" do |t|
      t.column :item_type_id, :integer
      t.column :service_id, :integer
      t.column :price, :decimal, :precision => 6, :scale => 2
    end
  end

  def self.down
    drop_table "services"
    drop_table "serviced_zips"
    drop_table "prices"
  end
end
