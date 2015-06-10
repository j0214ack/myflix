class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
    @videos_without_categories = Video.without_category
  end

  def show
    @video = Video.find(params[:id])
    @reviews = @video.reviews
    @review = Review.new
  end

  def search
    @search_value = params[:q]
    @search_results = Video.search_by_title(params[:q])
  end
end
