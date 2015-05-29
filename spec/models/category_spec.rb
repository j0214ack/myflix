require 'spec_helper'

describe Category do
  it "saves itself" do
    category = Category.new(name: "Some Category")
    category.save

    expect(category.valid?).to eq(true)
  end

  it "has many videos" do
    category = Category.create!(name: "A Category")
    video1 = Video.create!(title: "Lost", description: "A mysterious TV serie.",
                           category: category)
    video2 = Video.create!(title: "Lost2", description: "A mysterious TV serie2.",
                           category: category)

    expect(category.videos.size).to eq(2)
    expect(category.videos).to include(video1, video2)
  end
end
