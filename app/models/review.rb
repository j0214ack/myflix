class Review < ActiveRecord::Base

  RATING_RANGE = (1..5).to_a

  belongs_to :video
  belongs_to :user

  validates_presence_of :user_id, :video_id, :rating, :comment
  validates_uniqueness_of :user_id, scope: :video_id
end
