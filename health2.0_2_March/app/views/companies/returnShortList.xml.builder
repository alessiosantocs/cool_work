xml.instruct!
xml.companies do
  @companyList.each do |company|
    xml.company do
      xml.id company.id
      xml.name company.name
    end
  end
end
