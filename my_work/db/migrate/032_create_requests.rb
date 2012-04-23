class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.column :type, :string
      t.column :customer_id, :integer
      t.column :stop_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
