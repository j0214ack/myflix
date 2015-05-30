class VideosController < ApplicationController
  def index
    @categories = Category.all
    @videos_without_categories = Video.without_category
  end

  def show
    @video = Video.find(params[:id])
  end
end
