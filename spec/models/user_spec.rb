require 'spec_helper'

describe User do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_confirmation_of :password }
  it { is_expected.to validate_presence_of :full_name }
  it { is_expected.to have_secure_password }
  it { is_expected.to have_many :reviews }
  it { is_expected.to have_many :queue_items }

  describe '#queue_items' do
    it 'sorts by position' do
      user = Fabricate(:user)
      queue_item1 = Fabricate(:queue_item, user: user, position: 3)
      queue_item2 = Fabricate(:queue_item, user: user, position: 2)
      queue_item3 = Fabricate(:queue_item, user: user, position: 1)

      expect(user.queue_items).to eq [queue_item3,queue_item2,queue_item1]

    end
  end
end
