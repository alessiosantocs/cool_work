class RenameRequestTypeToRequestFor < ActiveRecord::Migration
  def self.up
    rename_column :requests, "type", "for"
  end

  def self.down
    rename_column :requests, "for", "type"
  end
end
