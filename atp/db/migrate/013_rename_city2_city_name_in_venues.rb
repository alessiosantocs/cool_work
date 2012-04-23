class RenameCity2CityNameInVenues < ActiveRecord::Migration
  def self.up
    rename_column :venues, :city, :city_name
  end

  def self.down
    rename_column :venues, :city_name, :city
  end
end
