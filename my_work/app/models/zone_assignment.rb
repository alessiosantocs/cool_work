# == Schema Information
# Schema version: 98
#
# Table name: zone_assignments
#
#  id          :integer(11)   not null, primary key
#  zone_id     :integer(11)   
#  location_id :integer(11)   
#

class ZoneAssignment < ActiveRecord::Base
  belongs_to :zone
  belongs_to :location
end
