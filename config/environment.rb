# Load the rails application
require File.expand_path('../application', __FILE__)

require 'tlsmail'    
Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)

require 'ruby_extensions'

ActionMailer::Base.default :from => "GFTL Bot <noreply@adeptivelabs.com>"
ActionMailer::Base.default :sender => "GFTL Bot <noreply@adeptivelabs.com>"
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,  
  :address            => 'smtp.gmail.com',
  :port               => 587,
  :tls                => true,
  :domain             => 'adeptivelabs.com', 
  :authentication     => :plain,
  :user_name          => 'noreply@adeptivelabs.com',
  :password           => 'E85666%%'
}

# Initialize the rails application
Gftl2::Application.initialize!
