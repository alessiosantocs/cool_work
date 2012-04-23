class AddImageSwitchBoardTable < ActiveRecord::Migration
  def self.up
    # create_table "image_switch_boards", :id => false, :force => true do |t|
    #   t.column "image_id",     :integer
    #   t.column "image_set_id", :integer
    #   t.column "medium_id",    :integer
    # end
    # add_index "image_switch_boards", ["image_id", "image_set_id"], :name => "idx_img_sb"
  end

  def self.down
    #drop_table :image_switch_boards
  end
end