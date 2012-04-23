# == Schema Information
# Schema version: 98
#
# Table name: notes
#
#  id          :integer(11)   not null, primary key
#  order_id    :integer(11)   
#  customer_id :integer(11)   
#  body        :text          
#  created_at  :datetime      
#  updated_at  :datetime      
#  note_type   :string(255)   default(""), not null
#

class Note < ActiveRecord::Base
  belongs_to :customer
  belongs_to :order
  
  liquid_methods :order, :customer, :body
end
