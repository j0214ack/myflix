class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "Access reserved for members only. Please sign in first."
      redirect_to root_path
    end
  end

  private

  def set_reviews(object)
    @reviews = object.reviews.includes(:user)
    if @reviews.any?
      total_rating = @reviews.map(&:rating).inject(&:+).to_f
      @average_rating = ( total_rating / @reviews.size).round(1)
    else
      @average_rating = 0.0
    end
    @rating_chioces = Review::RATING_RANGE.map { |n| ["#{n} Stars", n]  }
  end
end
