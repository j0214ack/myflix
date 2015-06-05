class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
    @videos_without_categories = Video.without_category
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews.includes(:user)
    if @reviews.any?
      @average_rating = (@reviews.map(&:rating).inject(&:+).to_f / @reviews.size)
                        .round(1)
    else
      @average_rating = 0.0
    end
    @rating_chioces = Review::RATING_RANGE.map { |n| ["#{n} Stars", n]  }
    @review = Review.new
  end

  def search
    @search_value = params[:q]
    @search_results = Video.search_by_title(params[:q])
  end

  def add_review
  end
end
