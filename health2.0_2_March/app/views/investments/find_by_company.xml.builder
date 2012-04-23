xml.instruct!
xml.investments do
  @angel.each do |item|
    xml.angel do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
  @seed.each do |item|
    xml.seed do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
    @seriesa.each do |item|
    xml.seriesa do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
    @seriesb.each do |item|
    xml.seriesb do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
    @seriesc.each do |item|
    xml.seriesc do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
    @seriesd.each do |item|
    xml.seriesd do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
    @seriese.each do |item|
    xml.seriese do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
    @seriesf.each do |item|
    xml.seriesf do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
    @seriesf.each do |item|
    xml.seriesf do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end


    @seriesg.each do |item|
    xml.seriesg do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
  
      @purchased.each do |item|
    xml.purchased do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
  
 @ipo.each do |item|
    xml.ipo do
      xml.id item.id
      xml.agency item.agency
      xml.tag! "funding-amount", item.funding_amount 
      xml.tag! "funding-type", item.funding_type
      xml.tag! "funding-date", item.funding_date
    end
  end
  
end
