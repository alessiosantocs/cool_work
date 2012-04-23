class EngineUpgrade < ActiveRecord::Migration
  def self.up
    #rename_table :engine_schema_info, :plugin_schema
  end

  def self.down
    #rename_table :plugin_schema, :engine_schema_info
  end
end