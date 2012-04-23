class Location < ActiveRecord::Base
  belongs_to :user
  belongs_to :image_set
  belongs_to :event
  belongs_to :party
  belongs_to :city
  
  class << self
    def post(data)
      self.delete_all("user_id=#{data[:user_id].to_i}")
      self.create(data)
    end
  end
end
