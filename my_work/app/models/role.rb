# == Schema Information
# Schema version: 98
#
# Table name: roles
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Role < ActiveRecord::Base
  
  def self.role(name)
    find(:first, :conditions => ["name LIKE ?", name])
  end
end
