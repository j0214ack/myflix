class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = current_user.reviews.build(review_params.merge(video: @video))
    if @review.save
      flash[:success] = 'Review added.'
      redirect_to @video
    else
      @reviews = @video.reviews
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
