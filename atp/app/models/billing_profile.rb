class BillingProfile < ActiveRecord::Base
  belongs_to :user
  
  def self.blank(options={})
    new({
      :country => SETTING["country"]
    }.merge(options))
  end
  
  validates_presence_of       :user_id, :last_4_numbers, :full_name, :address, :city, :state, :country, :postal_code
  validates_length_of         :last_4_numbers, :is => 4
  validates_length_of         :full_name, :within => 3..75
  validates_length_of         :address, :within => 3..75
  validates_length_of         :city, :within => 2..25
  validates_length_of         :state, :within => 2..25
  validates_length_of         :postal_code, :within => 3..10
  validates_length_of         :country, :is => 2
end