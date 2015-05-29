class VideosController < ApplicationController
  def index
    @categories = Category.all
    @videos_without_categories = Video.where(category_id: nil)
  end

  def show
    @video = Video.find(params[:id])
  end
end
