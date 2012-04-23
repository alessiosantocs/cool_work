class MoveCityId < ActiveRecord::Migration
  def self.up
    add_column "venues", "city_id", :integer, :limit => 10
    remove_column "parties", "city_id"
    execute "DROP INDEX email ON users"
    add_index "users", ["email"], :name => "email", :unique => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
