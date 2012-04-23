class AddStatTable < ActiveRecord::Migration
  def self.up
    create_table "stats" do |t|
      t.column "site_id", :integer, :limit => 2
      t.column "region_id", :integer, :limit => 3
      t.column "act", :string, :limit => 6
      t.column "obj_type", :string, :limit => 14
      t.column "user_id", :integer
      t.column "obj_id", :integer
      t.column "created_on", :datetime
    end
    add_index :stats, [:site_id, :region_id, :act, :obj_type], :name => "IDX_type_reg_site_act"
  end

  def self.down
    remove_index :stats, :name => :IDX_type_reg_site_act
    drop_table "stats"
  end
end
