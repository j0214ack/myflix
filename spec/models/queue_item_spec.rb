require 'spec_helper'

describe QueueItem do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :video }
  it { is_expected.to callback(:set_position).before(:validation).unless(:has_position?) }

  describe '#set_position' do
    it 'sets position' do
      queue_item = QueueItem.new
      queue_item.send(:set_position)
      expect(queue_item.position).to be
    end

    it 'sets unique positions for queue items which belong to the same user' do
      user = Fabricate(:user)
      queue_items = Fabricate.times(5, :queue_item, user: user)
      queue_item = QueueItem.new(user: user)
      queue_item.send(:set_position)

      expect(queue_items.map(&:position)).not_to include(queue_item.position)
    end
  end

  describe '#has_position?' do
    it 'returns true when queue item has a position value' do
      queue_item = QueueItem.new
      queue_item.position = 1

      expect(queue_item.send(:has_position?)).to be true
    end

    it 'returns false when queue item has no position value' do
      queue_item = QueueItem.new

      expect(queue_item.send(:has_position?)).to be false
    end
  end

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
