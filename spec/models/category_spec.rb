require 'spec_helper'

describe Category do
  it { should have_many :videos }

  describe "#recent_videos" do
    it "shows 6 most recent videos ordered by created_at descending order" do
      category = Category.create!(name: "Recent")
      videos = []
      videos << Video.create!(title: "Lost", description: "So lost", category: category)
      videos << Video.create!(title: "Lost 2", description: "Soooo lost", category: category)
      videos << Video.create!(title: "Lost 3", description: "So very lost", category: category)
      videos << Video.create!(title: "Family Guy", description: "Hahaha", category: category)
      videos << Video.create!(title: "Futurama", description: "Woooo", category: category)
      videos << Video.create!(title: "Monk", description: "Monk", category: category)
      videos << Video.create!(title: "Monk 2", description: "Monk 2", category: category)
      videos << Video.create!(title: "South Park", description: "South Park", category: category)

      expect(category.recent_videos).to eq(videos.reverse[0..5])
    end

    it "shows all videos if there is less than 6 videos" do
      category = Category.create!(name: "Recent")
      videos = []
      videos << Video.create!(title: "Lost", description: "So lost", category: category)
      videos << Video.create!(title: "Lost 3", description: "So very lost", category: category)
      videos << Video.create!(title: "Family Guy", description: "Hahaha", category: category)
      videos << Video.create!(title: "Monk", description: "Monk", category: category)

      expect(category.recent_videos).to eq(videos.reverse)
    end
  end


end
