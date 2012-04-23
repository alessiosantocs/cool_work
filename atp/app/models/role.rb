class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  
  validates_uniqueness_of     :name
  validates_presence_of       :name
  validates_length_of         :name,       :within => 3..25
  
  def self.blank(options={})
    new({
      :active => true
    }.merge(options))
  end
  
  def self.regional_rep
    Role.find_by_name("Regional Rep")
  end
end
