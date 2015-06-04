require 'spec_helper'


describe Video do
  it { is_expected.to belong_to :category }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }

  describe ".search_by_title" do
    let!(:videos) do
      videos = 5.times.map { |i| Fabricate(:video, title: "Lost #{i+1}") }
    end
    subject { lambda {|title| Video.search_by_title(title)} }

    it "returns an empty array if there are no matches" do
      expect(subject.call("no such title")).to eq([])
    end

    it "finds one video if there is only one match in videos" do
      expect(subject.call("Lost 5").size).to eq(1)
    end

    it "finds video that has a partially matched title" do
      expect(subject.call("ost 5").size).to eq(1)
    end

    it "finds all videos that matches the title" do
      expect(subject.call("Lost").size).to eq(5)
    end

    it "ignores letter cases" do
      expect(subject.call("lOst").size).to eq(5)
    end

    it "finds the correct results ordered by created_at descending" do
      expect(subject.call("lost")).to eq(videos.sort_by(&:created_at).reverse)
    end

    it "returns empty array if the search value is an empty string" do
      expect(subject.call("")).to eq([])
    end

    it "returns empty array if the search value is nil" do
      expect(subject.call(nil)).to eq([])
    end
  end
end
