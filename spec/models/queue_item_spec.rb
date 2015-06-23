require 'spec_helper'

describe QueueItem do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :video }

  describe '#rating' do
    it 'shows the rating of its video' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, video: video, user: user)
      queue_item = Fabricate(:queue_item, video: video, user: user)
      expect(queue_item.rating).to eq review.rating
    end
  end

  describe '#category' do
    it 'shows the category of its video' do
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq video.category
    end
  end
end
