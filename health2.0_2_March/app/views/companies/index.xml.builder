xml.instruct!
xml.companies do
  @companies.each do |company|
    xml.company do
      xml.id company.id
      xml.name company.name
      xml.founded company.founded
      xml.url company.url
      xml.description  company.description		
      xml.tag! "employee-number", company.employee_number
      xml.enabled company.enabled
    end
  end
end
