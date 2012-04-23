include Util
class Tool < Merb::Controller
  before :get_site
  def spotd
    @page_title = "Spotd: a way to keep track of the site as it happens"
    @list = Audit.recent.to_json
    render
  end
end