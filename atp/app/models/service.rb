class Service < ActiveRecord::Base
  belongs_to :user
  
  def self.blank(options={})
    new({
      :published => true
    }.merge(options))
  end
  
  def self.active
    find :all, :conditions => ("active = true")
  end
  
  validates_presence_of       :user_id, :business_name, :category_id, :name, :email, :phone, :description, :city, :state, :country
  validates_length_of         :business_name, :within => 3..45
  validates_length_of         :name, :within => 3..45
  validates_length_of         :description, :within => 10..2000
  validates_format_of         :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "is invalid."
  validates_length_of         :country, :is => 2
end