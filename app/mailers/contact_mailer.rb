class ContactMailer < ActionMailer::Base
 default to: 'zurch@appstoremedia.com'
  
    def contact_email(name, email, body)
        @name = name
        @email = email
        @body = body
        
        mail(from: email, subject: 'Contact from message')  
    end
end