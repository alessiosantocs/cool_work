class AddPartySiteIdx < ActiveRecord::Migration
  def self.up
    add_index :parties_sites, [:party_id, :site_id], :name => "idx_par_ste", :unique => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
