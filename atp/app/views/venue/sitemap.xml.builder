xml.instruct!
xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  xml.url do
    xml.loc         party_home_url
    xml.lastmod     @venues.first.created_on.w3c
    xml.changefreq  "daily"
  end
  @venues.each do |venue|
    xml.url do
      xml.loc         venue_url(venue)
      xml.lastmod     venue.created_on.w3c
      xml.changefreq  "daily"
    end
  end
end