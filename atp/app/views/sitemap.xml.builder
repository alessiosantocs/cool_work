xml.instruct!
xml.sitemapindex "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  @maps.each do |sitemap|
    xml.sitemap do
      xml.loc         "http://#{@host}/#{sitemap}"
      xml.lastmod     Time.now.w3c
    end
  end
end