class State < ActiveRecord::Base
  has_many :serviced_zips
  validates_presence_of :name
end
