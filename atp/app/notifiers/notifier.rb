class Notifier < ActionMailer::Base
  def signup_thanks( user, site)
    # Email header info MUST be added here
    @recipients = user.email
    @from = SETTING["welcome_email"]
    @subject = "Thank you for registering with #{SITE.full_name}" 

    # Email body substitutions go here
    @body["username"] = user.username
    @body["site"] = SITE.full_name
    @body["signature"] = SETTING["signature"]
  end
  
  def lost_password( user, site )
    # Email header info MUST be added here
    @recipients = user.email
    @from = SETTING["lost_password_email"]
    @subject = "[#{SITE.full_name}] Reset your password" 

    # Email body substitutions go here
    @body["username"] = user.username
    @body["user_id"] = user.id
    @body["link"] = user.member_login_key.reverse
    @body["site"] = SITE.full_name
    @body["site_url"] = "http://www.#{SITE.url}"
    @body["signature"] = SETTING["signature"]
  end
  
  def expiring_party(party, days_left)
    @recipients = party.user.email
    @from = SETTING["admin_email"]
    @subject = "[#{SITE.full_name}] NOTICE: #{party.title} at #{party.venue.name} has #{days_left} day(s) remaining.";
    @body["days_left"] = days_left
    @body["site_url"] = "http://www.#{SITE.url}"
    @body["days_refill_url"] = "http://www.#{SITE.url}" + "/account/manage"
    @body["party_title"] = party.title
    @body["venue_name"] = party.venue.name
    @body["signature"] = SETTING["signature"]
  end
  
  def rsvp_to_promoter(rsvp, party)
    @recipients = [party.rsvp_email, SETTING["notifier_email"] ]
    @from = rsvp.contact_email
    @party_title = "#{party.title} at #{party.venue.name}"
    @subject = "[#{SITE.full_name}] RSVP: #{@party_title}"
    @body["site_url"] = "http://www.#{SITE.url}"
    @body["party_url"] = "http://www.#{SITE.url}" + "/party/#{party.id}"
    @body["party_title"] = @party_title
    @body["contact_name"] = rsvp.contact_name
    @body["contact_phone"] = rsvp.contact_phone
    @body["contact_email"] = rsvp.contact_email
    @body["size"] = rsvp.size
    @body["party_type"] = rsvp.party_type
    @body["bottle_service"] = rsvp.bottle_service
    @body["signature"] = SETTING["signature"]
  end
end
