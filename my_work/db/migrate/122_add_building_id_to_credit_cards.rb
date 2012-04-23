class AddBuildingIdToCreditCards < ActiveRecord::Migration
  def self.up
		add_column :credit_cards, :building_id, :int
  end

  def self.down
		remove_column :credit_cards, :building_id
  end
end
