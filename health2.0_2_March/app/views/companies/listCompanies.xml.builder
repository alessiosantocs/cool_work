xml.instruct!
xml.companies do
  @companies.each do |company|
    xml.company do
      xml.id company[0]
      xml.name company[1]
    end
  end
end
