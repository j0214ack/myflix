require 'spec_helper'


describe Video do
  it { should belong_to :category }
  it { should validate_presence_of :title }
  it { should validate_presence_of :description }

  describe "#search_by_title" do
    it "returns an empty array if there are no matches" do
      Video.create!(title: "Lost", description: "So lost")
      Video.create!(title: "Lost 2", description: "Soooo lost")
      Video.create!(title: "Lost 3", description: "So very lost")
      Video.create!(title: "Family Guy", description: "Hahaha")
      Video.create!(title: "Futurama", description: "Woooo")


      expect(Video.search_by_title("no such title")).to eq([])
    end

    it "finds one video if there is only one match in videos" do
      Video.create!(title: "Lost", description: "So lost")
      Video.create!(title: "Lost 2", description: "Soooo lost")
      Video.create!(title: "Lost 3", description: "So very lost")
      Video.create!(title: "Family Guy", description: "Hahaha")
      Video.create!(title: "Futurama", description: "Woooo")

      search_result = Video.search_by_title("Family")

      expect(search_result.size).to eq(1)
    end

    it "finds all videos that matches the title" do
      Video.create!(title: "Lost", description: "So lost")
      Video.create!(title: "Lost 2", description: "Soooo lost")
      Video.create!(title: "Lost 3", description: "So very lost")
      Video.create!(title: "Family Guy", description: "Hahaha")
      Video.create!(title: "Futurama", description: "Woooo")

      search_result = Video.search_by_title("Lost")

      expect(search_result.size).to eq(3)
    end

    it "ignores letter cases" do
      Video.create!(title: "Lost", description: "So lost")
      Video.create!(title: "Lost 2", description: "Soooo lost")
      Video.create!(title: "Lost 3", description: "So very lost")
      Video.create!(title: "Family Guy", description: "Hahaha")
      Video.create!(title: "Futurama", description: "Woooo")

      search_result = Video.search_by_title("lost")

      expect(search_result.size).to eq(3)
    end

    it "finds the correct results" do
      lost = Video.create!(title: "Lost", description: "So lost")
      lost2 = Video.create!(title: "Lost 2", description: "Soooo lost")
      lost3 = Video.create!(title: "Lost 3", description: "So very lost")
      family_guy = Video.create!(title: "Family Guy", description: "Hahaha")
      futurama = Video.create!(title: "Futurama", description: "Woooo")

      lost_videos = [lost,lost2,lost3]

      search_result_lost = Video.search_by_title("lost")
      search_result_family = Video.search_by_title("family")

      expect(search_result_lost.sort_by { |video| video.title }).to eq(lost_videos)
      expect(search_result_family).to eq([family])
    end
  end
end
