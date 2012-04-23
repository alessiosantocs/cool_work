class AddColumnToService < ActiveRecord::Migration
  def self.up
    add_column :services ,:is_active ,:boolean , :default => true
  end

  def self.down
    remove_column :services ,:is_active
  end
end
