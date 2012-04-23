# == Schema Information
# Schema version: 98
#
# Table name: news
#
#  id         :integer(11)   not null, primary key
#  title      :string(255)   
#  body       :text          
#  user_id    :integer(11)   
#  created_at :datetime      
#  updated_at :datetime      
#

class News < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, :styles => { :medium => "200x200!"}
end
