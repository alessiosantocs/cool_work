require File.dirname(__FILE__) + '/../test_helper'
require '<%= controller_file_name %>_sitemap_controller'

# Re-raise errors caught by the controller.
class <%= controller_class_name %>SitemapController; def rescue_action(e) raise e end; end

class <%= controller_class_name %>SitemapControllerTest < Test::Unit::TestCase

  fixtures :<%= table_name %>

  def setup
    @controller = <%= controller_class_name %>SitemapController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_should_render_sitemap
    get :index
    assert_template "<%= table_name -%>/<%= controller_file_name -%>_sitemap"
    assert_response :success
    assert assigns(:host)
    assert assigns(:<%= table_name.pluralize -%>)
  end
  
  def test_should_be_valid_sitemap
    get :index
    assert_xml_tag  :tag => 'urlset' 
    assert_xml_tag  :tag => 'url', :parent => {:tag => 'urlset'}
    assert_xml_tag  :tag => 'lastmod', :parent => {:tag => 'url', :parent => {:tag => 'urlset'} }
    assert_xml_tag  :tag => 'changefreq', :parent => {:tag => 'url', :parent => {:tag => 'urlset'} }
  end
  
  def test_should_route_to_sitemap
    assert_routing "<%= controller_file_name -%>/sitemap", :controller => "<%= controller_file_name -%>_sitemap", :action => 'index'
  end
  
  def test_should_route_to_sitemap_index
    assert_routing "/sitemaps", :controller => "sitemaps", :action => 'index'
  end
  
  private
  
  def assert_xml_tag(*opts)
     clean_backtrace do
         opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
         tag = find_xml_tag(opts)
         assert tag, "expected tag, but no tag found matching #{opts.inspect} in:\n#{@response.body.inspect}"
     end
  end

  def assert_no_xml_tag(*opts)
     clean_backtrace do
         opts = opts.size > 1 ? opts.last.merge({ :tag => opts.first.to_s }) : opts.first
       tag = find_xml_tag(opts)
         assert !tag, "expected no tag, but found tag matching #{opts.inspect} in:\n#{@response.body.inspect}"
     end
  end
  
  def xml_document
     @xml_document ||= HTML::Document.new(@response.body, true, true) # strict, xml
  end

  def find_xml_tag(conditions)
     xml_document.find(conditions)
  end
  
end
