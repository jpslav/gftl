require 'active_support'

module MailerValues
  
  SUBJECT_PREFIX = "GFTL "
  
  
  DEFAULT_SENDER_EMAIL = ActionMailer::Base.smtp_settings[:user_name]
  
end