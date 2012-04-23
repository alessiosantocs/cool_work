class Site < ActiveRecord::Base
  has_and_belongs_to_many :regions
  has_and_belongs_to_many :parties
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  validates_uniqueness_of     :short_name, :full_name, :url
  validates_presence_of       :short_name, :full_name, :url
  validates_length_of         :short_name, :is => 3
  validates_format_of         :short_name, :with => /^([A-Za-z]+)$/i
  validates_length_of         :full_name, :within => 3..25
  validates_length_of         :url, :within => 7..128
end