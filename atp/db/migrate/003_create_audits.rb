class CreateAudits < ActiveRecord::Migration
  def self.up
    create_table :audits do |t|
      t.column :obj_type,   :string, :limit => 12, :default => nil
      t.column :obj_id,     :integer
      t.column :what,       :string, :limit => 24, :default => nil
      t.column :message,    :string, :limit => 128, :default => nil
      t.column :who,        :string, :limit => 24
      t.column :created_on, :datetime
    end
    add_index :audits, [:obj_type, :obj_id, :what], :name => "idx_type_id_what"
  end

  def self.down
    drop_table :audits
  end
end
