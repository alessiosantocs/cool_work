class CreateNotes < ActiveRecord::Migration
  def self.up
     create_table "notes" do |t|
      t.column :order_id, :integer
      t.column :customer_id, :integer
      t.column :note_type, :string
      t.column :body, :text
      
      t.timestamps
    end
  end

  def self.down
     drop_table "notes"
  end
end
