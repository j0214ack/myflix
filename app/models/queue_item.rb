class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_uniqueness_of :position, scope: :user_id
  before_validation :set_position, unless: :has_position?

  delegate :category, to: :video

  def rating
    review = video.reviews.find_by(user_id: user.id)
    review.rating if review
  end

  private

  def set_position
    self.position = QueueItem.where(user_id: self.user_id).count + 1
  end

  def has_position?
    !!self.position
  end
end
