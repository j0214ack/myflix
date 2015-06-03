class SessionsController < ApplicationController

  before_action require_user only: [:destroy]

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path
    else
      flash[:error] = "Something wrong."
      render :new
    end
  end

  def destroy
    if logged_in?
      session[:user_id] = nil
      flash[:info] = "Signed out."
      redirect_to root_path
    else
      flash[:success] = "You haven't logged in."
      redirect_to :back
    end
  end
end
