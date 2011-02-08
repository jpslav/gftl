# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  #include ExceptionNotifiable
  #include AuthenticatedSystem

  
  #before_filter :login_required
  
  before_filter :authenticate_user!
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password
  
  protected
  def admin_required
    (!current_user.nil? && current_user.is_administrator) || send_to_home
  end

  protected
  def send_to_home
    respond_to do |format|
      format.html do
        flash[:error] = "Black flag! You don't have permission to do that!"
        redirect_to :controller => :home
      end
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end
  
end
