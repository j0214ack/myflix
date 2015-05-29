require 'spec_helper'


describe Video do
  it "saves itself" do
    video = Video.new(title: "Lost", description: "A mysterious TV serie.")
    video.save
    expect(video.valid?).to eq(true)
  end

  it { should belong_to :category }

  it { should validate_presence_of :title }

  it { should validate_presence_of :description }

end
