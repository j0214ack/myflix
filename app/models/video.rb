class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true

  scope :without_category, -> { where(category_id: nil) }
end
