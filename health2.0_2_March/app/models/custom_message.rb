class CustomMessage < ActionMailer::Base
  helper :application

  def send_CustomMessage(recipientEmail, fromEmail, subjectEmail, bodyMessage)
     recipients recipientEmail 
     #bcc        ["bcc@example.com", "Order Watcher <watcher@example.com>"]
     from       fromEmail
     subject    subjectEmail
     body       bodyMessage
  end 

 # This is for when we send message to company list from my account
  def send_message_to_company(recipientEmail, fromEmail, subjectEmail, bodyMessage)
    @subject            = subjectEmail
    @body["body_message"] = bodyMessage
    @body["sent_to"]  = recipientEmail
    @recipients = recipientEmail
    @from  = fromEmail
    @content_type = "text/html"
    @headers = {}
  end 

  def send_mail_to_all_person_of_company(recipient, fromEmail, subject, message)
    @subject = subject
    @body["body_message"] =message
    @body["sent_to"]  = recipient
    @recipients = recipient
    @from = fromEmail
    @content_type = "text/html"
    @headers = {}
  end

  def send_alert_mail_to_return_email(recipientEmail)
    @subject = "Profile alert mail"
    @body["body_message"] = "Company profile has been changed"
    @body["sent_to"]  = recipientEmail
    @recipients = recipientEmail
    @from = "support@health2con.com"
    @content_type = "text/html"
    @headers = {}
    
  end

end
