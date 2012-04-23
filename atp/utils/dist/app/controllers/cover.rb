include Util
class Cover < Merb::Controller
  before :get_region_and_site

  def js
    @cover_images = CoverImage.site_and_region(@site, @region).collect{|c| c.image.link('cover_image') }
    render_js
  end
end