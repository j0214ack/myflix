require 'spec_helper'

describe Review do
  it { is_expected.to belong_to :video }
  it { is_expected.to belong_to :user }
  it { is_expected.to validate_presence_of :rating }
  it { is_expected.to validate_presence_of :comment }
  it { is_expected.to validate_presence_of :video_id }
  it { is_expected.to validate_presence_of :user_id }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:video_id) }
end
