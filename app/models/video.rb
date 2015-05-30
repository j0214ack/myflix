class Video < ActiveRecord::Base
  belongs_to :category

  validates :title, presence: true
  validates :description, presence: true

  scope :without_category, -> { where(category_id: nil) }

  def self.search_by_title
    #code
  end
end
