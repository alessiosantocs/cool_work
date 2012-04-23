class AddEachAdditionalOnPrices < ActiveRecord::Migration
  def self.up
    add_column :prices, :each_additional_standard, :decimal, :precision => 9, :scale => 2, :default => 0.0
    add_column :prices, :each_additional_premium, :decimal, :precision => 9, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :prices, :each_additional_standard
    remove_column :prices, :each_additional_premium
  end
end
