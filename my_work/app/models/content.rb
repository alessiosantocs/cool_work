# == Schema Information
# Schema version: 98
#
# Table name: contents
#
#  id            :integer(11)   not null, primary key
#  address       :text          
#  phone         :string(255)   
#  email         :string(255)   
#  eco_value_1   :string(255)   
#  eco_value_2   :string(255)   
#  eco_value_3   :string(255)   
#  title         :string(255)   
#  body          :text          
#  link          :string(255)   
#  link_text     :text          
#  sub_title     :string(255)   
#  sub_body      :text          
#  sub_link      :string(255)   
#  sub_link_text :text          
#  created_at    :datetime      
#  updated_at    :datetime      
#

class Content < ActiveRecord::Base
end
