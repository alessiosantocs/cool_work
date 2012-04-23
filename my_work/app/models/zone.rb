# == Schema Information
# Schema version: 98
#
# Table name: zones
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Zone < ActiveRecord::Base
  has_one :location, :as => :target
  has_many :zone_assignments
  has_many :locations, :through => :zone_assignments
  
  
  
  def add(location)
    if location.class == Location
      self.locations << location
    else
      self.locations << location.location
    end
  end
  
  def is_in(superzone)
    self.location.is_in(superzone)
  end
  def contains(subzone)
    self.location.contains(subzone)
  end
  
  def unique_locations
    loc_array = self.locations.dup
    #pp loc_array
    end_of_array = loc_array.length
    to_delete = []
    loc_array.uniq.each_index do |i|
      #pp "index = " + i.to_s
      ((i+1)..(loc_array.length-1)).to_a.each do |j|
        #pp "j = " + j.to_s
        if not (to_delete.include? i or to_delete.include? j)
        #pp loc_array[j].to_s + " is in " + loc_array[i].to_s + " => " + loc_array[j].is_in(loc_array[i]).to_s
        if loc_array[j].is_in(loc_array[i])
          to_delete << j
        elsif loc_array[j].contains(loc_array[i])
          to_delete << i
        end
        end
      end
    end
    to_delete.uniq.each do |d|
      loc_array.delete_at(d)
    end
    loc_array
  end
  def density(clean = false)
    d = 0
    if not clean
      self.unique_locations.each do |l|
        d += l.density
      end
    else
      self.locations do |l|
        d += l.density
      end
    end
    d
  end
  
  def clean
    self.locations = self.unique_locations
    self.save!
  end

end
