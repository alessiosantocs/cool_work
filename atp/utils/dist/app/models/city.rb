class City < ActiveRecord::Base
  has_many :parties, :dependent => :destroy
  has_many :cover_images, :dependent => :destroy
  belongs_to :region
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  validates_uniqueness_of     :short_name, :full_name
  validates_presence_of       :short_name, :full_name, :region_id
  validates_length_of         :short_name,    :is => 3
  validates_length_of         :full_name,     :within => 3..25
  validates_format_of         :short_name, :with => /^([A-Za-z]+)$/i
end