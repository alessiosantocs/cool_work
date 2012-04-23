class Region < ActiveRecord::Base
  has_and_belongs_to_many :sites
  has_many :cities
  has_many :venues, :through => :cities
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  validates_uniqueness_of     :short_name, :full_name
  validates_presence_of       :short_name, :full_name
  validates_length_of         :short_name,    :is => 3
  validates_length_of         :full_name,     :within => 3..25
  validates_format_of         :short_name, :with => /^([A-Za-z]+)$/i
end
