require 'spec_helper'


describe Video do
  it "saves itself" do
    video = Video.new(title: "Lost", description: "A mysterious TV serie.")
    video.save
    expect(video.valid?).to eq(true)
  end

  it "belongs to a category" do
    category = Category.create!(name: "my_category")
    video = Video.create!(title: "Lost", description: "A mysterious TV serie.",
                          category: category)

    expect(video.valid?).to eq(true)
    expect(video.category).to eq(category)
  end
end
