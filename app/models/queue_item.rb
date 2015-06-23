class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  delegate :category, to: :video

  def rating
    review = video.reviews.find_by(user_id: user.id)
    review.rating if review
  end
end
