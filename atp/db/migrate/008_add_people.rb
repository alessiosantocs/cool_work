class AddPeople < ActiveRecord::Migration
  def self.up
    create_table "friends", :force => true do |t|
      t.column "fp", :integer
      t.column "fc", :integer
      t.column "a", :integer, :limit => 1
    end
    add_index :friends, [:fp, :fc], :name => "fpfc", :unique => true
    
    add_column "users", "relationship_status", :string, :limit => 22
    add_column "users", "your_desc", :text
    add_column "users", "match_desc", :text
    
    create_table "phrases" do |t|
      t.column "term", :string, :limit => 32
    end
    
    create_table "phrases_users" do |t|
      t.column "user_id", :integer
      t.column "phrase_id", :integer
      t.column "type", :string, :limit => 12
    end
    add_index :phrases_users, [:type, :user_id, :phrase_id], :name => "type_user_phrase"
  end

  def self.down
    remove_index :friends, :name => :fpfc
    drop_table :friends
    remove_column "users", "relationship_status"
    remove_column "users", "your_desc"
    remove_column "users", "match_desc"
    drop_table "phrases"
    remove_index :phrases_users, :name => :type_user_phrase
    drop_table "phrases_users"
  end
end
