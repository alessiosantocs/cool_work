class AddImageUrl < ActiveRecord::Migration
  def self.up
    add_column :services, :image_url, :string, :default => 'other.jpg'
    wash = Service.find_by_name('Wash and Fold')
    if !wash.blank?
      wash.image_url = 'wash_and_fold.jpg'
      wash.save
    end
    shoes = Service.find_by_name('Shoes')
    if !shoes.blank?
      shoes.image_url = 'myshoes.jpg'
      shoes.save
    end
    dry = Service.find_by_name('Dry Cleaning')
    if !dry.blank?
      dry.image_url = 'dry_clean.jpg'
      dry.save
    end
  end
  
  def self.down
    remove_column :services, :image_url
  end
end
