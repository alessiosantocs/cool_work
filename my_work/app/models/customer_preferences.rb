# == Schema Information
# Schema version: 98
#
# Table name: customer_preferences
#
#  id                  :integer(11)   not null, primary key
#  customer_id         :integer(11)   
#  wf_temperature      :string(255)   
#  wf_fabric_softener  :boolean(1)    
#  wf_bleach           :boolean(1)    
#  ls_starch           :boolean(1)    default(TRUE)
#  ls_press            :boolean(1)    default(TRUE)
#  ls_packaging        :string(255)   
#  dc_starch           :boolean(1)    default(TRUE)
#  dc_press            :boolean(1)    default(TRUE)
#  permanent_tags      :boolean(1)    
#  day_before_email    :boolean(1)    
#  day_before_sms      :boolean(1)    
#  day_of_email        :boolean(1)    
#  day_of_sms          :boolean(1)    
#  preferred_contact   :string(255)   
#  doorman_permission  :boolean(1)    
#  my_fresh_water      :boolean(1)    
#  my_fresh_air        :boolean(1)    
#  wants_updates       :boolean(1)    
#  wants_promotions    :boolean(1)    
#  email_format        :string(255)   
#  wants_minor_repairs :boolean(1)    
#

class CustomerPreferences < ActiveRecord::Base
    belongs_to :customer
end
