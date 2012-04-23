class CreateBgTaskTable < ActiveRecord::Migration
  def self.up
    create_table :bg_tasks do |t|
      t.column :obj_type,   :string, :limit => 12, :default => nil
      t.column :obj_id,     :integer
      t.column :user_id,    :integer
      t.column :message,    :text
      t.column :status,     :string, :limit => 32
      t.column :created_at, :datetime
      t.column :completed_at, :datetime
    end
    add_index :bg_tasks, [:obj_type, :obj_id, :user_id], :name => "idx_bg_tsk"
  end

  def self.down
    drop_table :bg_tasks
  end
end
