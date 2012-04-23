module <%= table_name.titleize %>SitemapHelper
  #Make sure to remove this here and include it
  #in the application helper if you're generating more sitemaps
  
  #credit: http://www.codeism.com/archive/show/578
  def w3c_date(date)
    date.utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
end