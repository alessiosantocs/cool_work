class Item < ActiveRecord::Base
  has_and_belongs_to_many :orders
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  validates_presence_of       :name, :description, :price, :active
  validates_length_of         :name, :within => 3..30
  validates_length_of         :description,   :within => 3..1000
  validates_numericality_of   :price
end

class Tickets < Item

end

class Trips < Item

end