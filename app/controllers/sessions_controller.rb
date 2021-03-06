class SessionsController < ApplicationController
  def index
    @user = User.new
    if current_user
      redirect_to :controller => 'home', :action => 'index'
    end
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new
    # OmniAuth Request
    if !request.env['omniauth.auth'].nil?
      auth = request.env['omniauth.auth']
      authorization = Authorization.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Authorization.create_with_omniauth(auth)
      session[:uid] = authorization['id']
      flash[:success] = "You have been logged in via Facebook."
      redirect_to :controller => 'home', :action => 'index'
    else
      # Regular authentication request
      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        flash[:success] = "You are now Logged in!"
        redirect_to :controller => 'home', :action => 'index'
      else
        flash[:error] = "Invalid email or password."
        redirect_to root_path
      end
    end
  end
  
  def refresh
  end

  def destroy
    @user = User.new
    session[:user_id] = nil
    session[:uid] = nil
    flash[:success] = "You have been Logged Out!"
    redirect_to(root_path)
  end

end
