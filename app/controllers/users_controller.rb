class UsersController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:become]
  before_filter :admin_required, :except => [:become]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    @user.is_administrator = params[:user][:is_administrator]
    @user.save
    # if params[:user][:disable].blank?
    #   @user.enable!
    # else
    #   @user.disable!
    # end
    
    # respond_with(@user)
  end
  
  def become
    raise SecurityTransgression unless Rails.env.development? || current_user.is_administrator
    
    sign_in(:user, User.find(params[:user_id]))
    redirect_to  root_path
  end

end
