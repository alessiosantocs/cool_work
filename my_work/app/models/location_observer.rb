class LocationObserver < ActiveRecord::Observer
  observe ServicedZip, Building, Address, Zone
  
  def after_save(model)
    if model.location == nil:
      model.location = Location.new(:target => model)
    end
  end
end
