require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < Test::Unit::TestCase
  fixtures :sites
  
  def setup
    @site = Site.find 1
  end
  
  def test_should_create_site
    s = create_site()
    assert s.valid?
  end
  
  def test_count_my_fixtures
    assert_equal 3, Site.count
    assert_equal 2, Site.active.length
  end

  def test_should_require_url
    s = create_site(:url => nil)
    assert s.errors.on(:url)
  end

  def test_destroy
    @site.destroy
    assert_raise(ActiveRecord::RecordNotFound) { Site.find @site.id }
  end
  
  def test_validate
    assert_equal 1, @site.id
    @site.short_name = '123'
    assert !@site.save
    #puts @sites.errors.full_messages
    assert_equal 1, @site.errors.count
  end
  
  def test_read_with_hash
    assert_kind_of Site, @site
    assert_equal 1, @site.id
    assert_equal 'atp', @site.short_name
    assert_equal 'AllTheParties', @site.full_name
    assert_equal 'www.alltheparties.com', @site.url
    assert_equal true, @site.active
    
    @site = sites(:third)
    assert_kind_of Site, @site
    assert_equal 3, @site.id
    assert_equal 'alc', @site.short_name
    assert_equal 'latino clubs', @site.full_name
    assert_equal 'www.latclub.com', @site.url
    assert_equal false, @site.active
  end
  
  def test_these_properties
    s = create_site(:short_name => nil)
    assert s.errors.on(:short_name)
    s = create_site(:full_name => nil)
    assert s.errors.on(:full_name)
    s = create_site(:url => nil)
    assert s.errors.on(:url)
  end
  
  protected
  def create_site(options = {})
    Site.create({ 
      :short_name => 'hop', 
      :full_name => 'Houston Playaz', 
      :url => 'www.houstonplayaz.com', 
      :comments_allowed => false, 
      :active => false }.merge(options))
  end
end
