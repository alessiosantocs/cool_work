class AddHexColor < ActiveRecord::Migration
  def self.up
    add_column :trucks, :hex_color, :string, :limit => 6, :default => 'CC3333'
  end

  def self.down
    remove_column :users, :hex_color
  end
end
