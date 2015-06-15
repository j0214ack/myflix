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
    if queue_item.user == current_user
      queue_item.destroy
    else
      flash[:error] = "You can't do that."
    end
    redirect_to :back
  end

  def batch_update
    unless params[:queue_item].map{|_, value| value[:position]}.uniq!
      QueueItem.transaction do
        params[:queue_item]
          .sort_by { |_, value| value[:position] }.map{ |id, _| id}
          .each_with_index do |id, index|
            item = QueueItem.find(id)
            item.position = index + 1
            item.save
          end
      end
    else
      flash[:error] = "There were duplications in your positions"
    end

    redirect_to my_queue_path
  end
end
