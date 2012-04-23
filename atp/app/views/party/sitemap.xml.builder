xml.instruct!
xml.urlset "xmlns" => "http://www.google.com/schemas/sitemap/0.84" do
  xml.url do
    xml.loc         party_home_url
    xml.lastmod     @parties.first.updated_on.w3c
    xml.changefreq  "daily"
  end
  @parties.each do |party|
    unless party.venue.nil?
    xml.url do
      xml.loc         party_url(party)
      xml.lastmod     party.created_on.w3c
      xml.changefreq  "daily"
    end
    end
  end
end