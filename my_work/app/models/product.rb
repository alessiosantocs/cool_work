# == Schema Information
# Schema version: 98
#
# Table name: products
#
#  id          :integer(11)   not null, primary key
#  name        :string(255)   
#  description :text          
#  price       :decimal(9, 2) 
#  created_at  :datetime      
#  updated_at  :datetime      
#

class Product < ActiveRecord::Base
  has_many   :order_products
  
end
