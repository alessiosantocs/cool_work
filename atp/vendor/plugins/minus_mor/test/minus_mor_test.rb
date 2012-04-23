# Need to run tests from inside a rails app for now
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/minus_mor'

class MockController < ActionController::Base
  
  attr_accessor :headers
  
  def initialize
    @headers = {}
  end
end

class MockView 
  attr_accessor :controller, :assigns
  
  def initialize(controller)
    @controller = controller
    @assigns = { :thing => 4, :hash => { :a => 4, :b => 5 } }
  end
end

class MinusMORTest < Test::Unit::TestCase
  
  def setup
    @controller = MockController.new
    @action_view = MockView.new @controller
  end
  
  def test_should_set_content_type_to_js
    view = MinusMOR::View.new(@action_view)
    view.render('', {})
    assert @controller.headers['Content-Type'] =~ /text\/javascript/
  end
  
  def test_should_render_erb
    view = MinusMOR::View.new(@action_view)
    r = view.render('<%= 5 + 5 %>', {})
    assert_equal '10', r
  end
  
  def test_should_have_instance_variables_available
    view = MinusMOR::View.new(@action_view)
    r = view.render('Boob: <%= @thing %>', {})
    assert_equal 'Boob: 4', r
  end
  
  def test_js_helper_should_call_to_json_on_args
    view = MinusMOR::View.new(@action_view)
    r = view.render('<%=js @hash %>', {})
    assert_equal @action_view.assigns[:hash].to_json, r
  end
  
  # TODO: test rendering of partials...need a bigger test setup
  
end
