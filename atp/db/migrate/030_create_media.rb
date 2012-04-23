class CreateMedia < ActiveRecord::Migration
  def self.up
    create_table :media do |t|
      t.column :parent_id,  :integer
      t.column :type, :string, :limit => 20
      t.column :obj_type, :string, :limit => 20
      t.column :obj_id, :integer
      t.column :user_id, :integer, :limit => 10
      t.column :caption, :string, :limit => 255
      
      t.column :content_type, :string, :limit => 128
      t.column :filename, :string, :limit => 128
      t.column :thumbnail, :string, :limit => 128
      t.column :size, :integer
      
      t.column :width, :integer, :limit => 4
      t.column :height, :integer, :limit => 4
      t.column :position, :integer, :limit => 5
      t.column :comments_allowed, :boolean
      t.column :tmp, :boolean
      t.column :created_on, :datetime
      t.column :updated_on, :datetime
    end
    
    # add to version 32
    # add_index :media, [ :type, :obj_type, :obj_id, :parent_id, :user_id], :name => "idx_media"
  end

  def self.down
    drop_table :media
  end
end
