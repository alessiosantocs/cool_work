class AddExtensionsToPhoneNumbers < ActiveRecord::Migration
  def self.up
    add_column :customers, :work_extension, :string, :limit => 10
  end

  def self.down
    remove_column :customers, :work_extension
  end
end
