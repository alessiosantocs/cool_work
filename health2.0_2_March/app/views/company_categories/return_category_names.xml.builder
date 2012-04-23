xml.instruct!
xml.categories do
  @catList.each do |item|
   xml.name item
  end
end
