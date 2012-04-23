module PartyHelper
  def show_flyer(event, size="flyer")
    #if event flyer exists
    unless event.flyer.nil?
      "<a href='#{event.flyer.image.link('large')}' rel='lightbox[party]' title='#{event.search_date}: #{event.party.title} at #{event.venue.name}'>#{show_img(event.flyer.image, size)}</a>"
    else
      #if party exists
      unless event.party.flyer.nil?
        "<a href='#{event.party.flyer.image.link('large')}' rel='lightbox[party]' title='#{event.search_date}: #{event.party.title} at #{event.venue.name}'>#{show_img(event.party.flyer.image, size)}</a>"
      else
        #if all else fails
        img_na(size)
      end
    end
  end
  
  def rsvp_form(party, source="local")
    if source == "party"
      action = "/rsvp/#{party.id}"
    else
      action = "http://www.#{SITE.url}/rsvp/#{party.id}"
    end
    <<-EOL
    <form id="rsvp_form" method="post" action="#{action}">
    #{hidden_field "booking", "source", { :value => source }}
      <p>
        <label for"booking_contact_name">Name:</label> #{text_field "booking", "contact_name", {"size" => 20, "maxlength" => 45 }}
      </p>
    
      <p>
        <label for"booking_contact_email">Email:</label> #{text_field "booking", "contact_email", {"size" => 20, "maxlength" => 65 }}
      </p>
    
      <p>
        <label for"booking_contact_phone">Phone:</label> #{text_field "booking", "contact_phone", {"size" => 12, "maxlength" => 15 }}
      </p>
    
      <p>
        <label for"booking_party_type">Occassion:</label> #{select "booking", "party_type", Booking.types.sort.collect {|k,v| [ v, k ] }, { :include_blank => true }}
      </p>
    
      <p>
        <label for"booking_size">Number of Guests:</label> #{text_field "booking", "size", {"size" => 4, "maxlength" => 3 }}
      </p>
    
      <p>
        <label for"booking_bottle_service">Bottle Service:</label> #{check_box "booking", "bottle_service"} Yes
      
      </p>
    
      <p>
        <label>&nbsp;&nbsp;</label><input name="submit" value="Submit" type="submit">
      </p>
    </form>
    EOL
  end
end