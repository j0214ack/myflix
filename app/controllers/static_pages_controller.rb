class StaticPagesController < ApplicationController
  def landing
    redirect_to home_path if logged_in?
  end
end
