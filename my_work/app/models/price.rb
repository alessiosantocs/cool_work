# == Schema Information
# Schema version: 98
#
# Table name: prices
#
#  id           :integer(11)   not null, primary key
#  item_type_id :integer(11)   
#  service_id   :integer(11)   
#  price        :decimal(6, 2) 
#  water        :decimal(9, 2) 
#  carbon       :decimal(9, 2) 
#  point_value  :integer(11)   
#  premium      :decimal(9, 2) default(0.0)
#

class Price < ActiveRecord::Base
  belongs_to :service
  belongs_to :item_type
  validates_numericality_of :water, :price, :premium, :carbon, :point_value

  def get_plant_price(premium, weight=nil)
      unless self.service.name == 'Wash and Fold'
          weight = 1 if weight == 0 or weight == nil
          return weight * self.plant_price unless(premium)
          return weight * self.plant_premium_price
      else
        price = premium ? self.plant_premium_price : self.plant_price 
        return [weight-10,0].max * price + price * 10
      end
  end
end
