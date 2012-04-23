class UpdateServices < ActiveRecord::Migration
  def self.up
    services = Service.find(:all)
    for service in services
      service.is_itemizeable = true
      service.is_detailable = true
      service.is_weighable = false
      service.save!
    end
  end

  def self.down
  end
end
