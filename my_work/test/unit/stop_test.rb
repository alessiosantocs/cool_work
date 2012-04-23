require File.dirname(__FILE__) + '/../test_helper'
require 'db/migrate/populate_regular_windows'

class StopTest < ActiveSupport::TestCase
  fixtures :serviced_zips, :locations, :orders
  # Replace this with your real tests.
  def test_truth
    r = Request.new()
  end
  
  def test_make_request
    s = Stop.create(:slots => 5, :date => Date.today(), :complete => false, :location_id => locations(:l8), :window_id => Window.find(4).id)
    r = s.make_request(orders(:Stallmans_first_order), :pickup)
    assert r.for == "pickup"
    assert r.stop.date == Date.today()
    assert r.order_id == 1
    pp r
  end
  
  def test_count_functions
    s = Stop.create(:slots => 5, :date => Date.today(), :complete => false, :location_id => locations(:l8), :window_id => Window.find(4).id)
    r1 = s.make_request(orders(:Stallmans_first_order), :pickup)
    r2 = s.make_request(orders(:Stallmans_second_order), :delivery)
    r3 = s.make_request(orders(:Sussmans_first_order), :pickup)
    r1.save!
    r2.save!
    r3.save!
    assert s.request_count == 3
    assert s.isolated_request_count + s.concordant_request_count == s.request_count
    assert s.slots_left == 2 #this is going to change when requests know if they need to take a slot
  end
end
