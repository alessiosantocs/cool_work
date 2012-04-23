#---
# Excerpted from "Advanced Rails Recipes",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fr_arr for more book information.
#---
class CreateFourOhFours < ActiveRecord::Migration
  
  def self.up
    create_table :four_oh_fours do |t|
      t.column :host, :string, :limit => 128
      t.column :path, :string, :limit => 255
      t.column :referer, :string, :limit => 128
      t.column :count,  :integer, :default => 0
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    # add_index :four_oh_fours, [:host, :path, :referer], :unique => true
    add_index :four_oh_fours, [:path]
  end

  def self.down
    drop_table :four_oh_fours
  end
end
