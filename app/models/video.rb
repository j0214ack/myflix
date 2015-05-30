class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true

  scope :without_category, -> { where(category_id: nil) }

  def self.search_by_title(search_value)
    wild_card_search = "%#{search_value.downcase}%"
    Video.where("lower(title) LIKE ?", wild_card_search).order("created_at DESC")
  end
end
