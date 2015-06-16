class QueueItemsController < ApplicationController
  before_action :require_user
  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    if current_user.queue_items.find_by(video_id: video.id)
      flash[:error] = 'The video was already in your queue.'
    else
      current_user.queue_items.create(video: video)
    end
    redirect_to video
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    unless queue_item.try(:destroy_by_user, current_user)
      flash[:error] = "You can't do that."
    end
    redirect_to :back
  end

  def batch_update
    unless QueueItem.batch_update_by_user(current_user, params[:queue_items])
      flash[:error] = "Something wrong."
    end

    redirect_to my_queue_path
  end
end
