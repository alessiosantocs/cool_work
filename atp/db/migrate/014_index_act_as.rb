class IndexActAs < ActiveRecord::Migration
  def self.up
    add_index :images, [:user_id], :name => "idx_imgs", :unique => false
    add_index :image_sets, [:obj_id, :obj_type, :image_id], :name => "idx_imgset", :unique => false
    add_index :comments, [:commentable_id, :commentable_type, :user_id ], :name => "idx_cmnt", :unique => false
    add_index :votes, [:voteable_id, :voteable_type, :user_id ], :name => "idx_vote", :unique => false
    add_index :faves, [:user_id, :obj_id, :obj_type], :name => "idx_fave", :unique => false
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
