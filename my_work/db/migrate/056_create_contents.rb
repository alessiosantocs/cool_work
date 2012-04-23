class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.text :address
      t.string :phone
      t.string :email
      t.string :eco_value_1
      t.string :eco_value_2
      t.string :eco_value_3
      t.string :title
      t.text :body
      t.string :link
      t.text :link_text
      t.string :sub_title
      t.text :sub_body
      t.string :sub_link
      t.text :sub_link_text

      t.timestamps
    end
    
    Content.create!
  end

  def self.down
    drop_table :contents
  end
end
