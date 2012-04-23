# == Schema Information
# Schema version: 98
#
# Table name: instructions
#
#  id   :integer(11)   not null, primary key
#  text :text          
#

class Instructions < ActiveRecord::Base
  has_one :customer_item
  has_one :order
  has_one :order_items
end
