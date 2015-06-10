require 'spec_helper'


describe Video do
  it { is_expected.to belong_to :category }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to have_many :reviews }

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

  describe '#reviews' do
    it 'sorts reviews from newest to oldest' do
      video = Fabricate(:video)
      reviews = Fabricate.times(3,:review, video: video)

      expect(video.reviews).to eq(reviews.sort_by(&:created_at).reverse)
    end
  end

  describe "#average_rating" do
    it 'returns nil when there is no reviews' do
      video = Fabricate(:video)

      expect(video.average_rating).to be_nil
    end

    it 'returns the review rating when there is only one review' do
      video = Fabricate(:video)
      review = Fabricate(:review, video: video)

      expect(video.average_rating).to eq(review.rating)
    end

    it 'returns the average review rating rounded to 1 when there are multiple reviews' do
      video = Fabricate(:video)
      reviews = Fabricate.times(3, :review, video: video)
      average_rating = reviews.map(&:rating).inject(&:+).to_f / 3

      expect(video.average_rating).to eq(average_rating.round(1))
    end

  end
end
