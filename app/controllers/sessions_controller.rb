class SessionsController < ApplicationController

  before_action :require_user, only: [:destroy]

  def new
    if logged_in?
      flash[:error] = "You already signed in."
      redirect_to home_path
    end
  end

  def create
    if logged_in?
      flash[:error] = "You already signed in."
      redirect_to home_path
    else
      user = User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        flash[:success] = "Welcome back, #{user.full_name}!"
        session[:user_id] = user.id
        redirect_to home_path
      else
        flash.now[:error] = "Invalid password or E-mail!"
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Signed out."
    redirect_to root_path
  end
end
