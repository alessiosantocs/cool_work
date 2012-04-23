xml.instruct!
xml.companies do
  @results.each do |company|
    xml.company do
      xml.id company._id.to_s
      xml.name company.name
      xml.description company.description
    end
  end
  @company_categories.each do |cc|
     xml.tag! "company-category" do
      xml.tag! "category-id",  cc["category-id"]
      xml.tag! "company-id",  cc["company-id"]
     end
   end
end

