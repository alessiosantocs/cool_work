xml.instruct!
xml.companies do
  @company.each do |company|
    xml.company do
      xml.id company.id
      xml.name company.name
      xml.enabled company.enabled
    end
  end
  @company_categories.each do |cc|
     xml.tag! "company-category" do
      xml.tag! "category-id",  cc.category_id
      xml.tag! "company-id",  cc.company_id
     end
   end
end

