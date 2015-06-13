class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order "created_at DESC" }
  has_many :queue_items

  validates :title, presence: true
  validates :description, presence: true

  scope :without_category, -> { where(category_id: nil) }

  def self.search_by_title(search_value)
    return [] if search_value.blank?
    where("lower(title) LIKE ?", "%#{search_value.downcase}%").order("created_at DESC")
  end

  def average_rating
    if reviews.size > 0
      total_rating = reviews.map(&:rating).inject(&:+).to_f
      (total_rating / reviews.size).round(1)
    end
  end

  def queue_item_of(user)
    queue_items.find_by(user_id: user.id)
  end
end
