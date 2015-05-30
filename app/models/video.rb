class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true

  scope :without_category, -> { where(category_id: nil) }

  def self.search_by_title(search_value)
    return [] if search_value.blank?
    where("lower(title) LIKE ?", "%#{search_value.downcase}%").order("created_at DESC")
  end
end
