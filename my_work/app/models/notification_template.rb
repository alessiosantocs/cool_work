# == Schema Information
# Schema version: 98
#
# Table name: notification_templates
#
#  id         :integer(11)   not null, primary key
#  name       :string(255)   
#  mail_body  :text          
#  sms_body   :text          
#  created_at :datetime      
#  updated_at :datetime      
#

class NotificationTemplate < ActiveRecord::Base
  validates_length_of :sms_body, :maximum => 140, :allow_nil => true, :allow_blank => true
end
