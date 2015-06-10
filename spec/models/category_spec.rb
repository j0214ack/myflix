require 'spec_helper'

describe Category do
  it { is_expected.to have_many :videos }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }

  let(:category) { Fabricate(:category) }
  describe "#recent_videos" do
    let(:subject) { category.recent_videos }
    it "shows no videos when there is no videos" do
      expect(subject).to eq([])
    end

    it "shows one video when there is only one video" do
      video = Fabricate(:video, category: category)
      expect(subject).to eq([video])
    end

    it "shows all videos if there is less than 6 videos" do
      videos = Fabricate.times(4, :video, category: category)
                        .sort_by(&:created_at).reverse

      expect(subject).to eq(videos)
    end

    it "shows 6 most recent videos ordered by created_at descending order" do
      videos = Fabricate.times(7, :video, category: category)
                        .sort_by(&:created_at).reverse

      expect(subject).to eq(videos[0..5])
    end
  end

end
