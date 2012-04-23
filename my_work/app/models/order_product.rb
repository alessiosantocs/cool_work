# == Schema Information
# Schema version: 98
#
# Table name: order_products
#
#  id         :integer(11)   not null, primary key
#  order_id   :integer(11)   
#  product_id :integer(11)   
#  quantity   :integer(11)   
#  price      :decimal(9, 2) 
#  created_at :datetime      
#  updated_at :datetime      
#

class OrderProduct < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  
  def name
    self.product.name
  end
  
  def carbon_cost
    if self.product.name == 'Carbon Credit'
      return -self.quantity
    end
    return 0
  end
  
  def water_cost
    if self.product.name == 'Water Credit'
      return -self.quantity
    end
    return 0
  end
end
