require 'spec_helper'
require 'shared_examples'

describe ReviewsController do
  describe 'POST create' do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    context 'when user signed in' do
      before(:each) do
        login_user(user)
      end

      context 'when provided with valid information' do
        let(:info) do
          Fabricate.attributes_for(:review, video: nil, user: nil)
        end
        before(:each) do
          post :create, video_id: video.id, review: info
        end

        it 'creates the review' do
          review = Review.first
          expect(review).to be
        end

        it 'associates the review to the video' do
          review = Review.first
          expect(review.video).to eq(video)
        end

        it 'associates the review to the user' do
          review = Review.first
          expect(review.user).to eq(user)
        end

        it 'redirects to video page' do
          expect(response).to redirect_to video_path(video)
        end

        it 'sets flash[:success]' do
          expect(flash[:success]).to be_present
        end
      end # context when provided with valid information

      context 'when provided with invalid information' do
        let(:reviews) { video.reviews }
        before(:each) do
          post :create, video_id: video.id, review: { rating: 1, comment: '' }
        end

        it_behaves_like 'a video show page'
      end

      context 'when user already created a review on this video' do
        let!(:review) { Fabricate(:review, video: video, user: user) }
        let(:reviews) { video.reviews }
        let(:info) do
          Fabricate.attributes_for(:review, video: video, user: user)
        end
        before(:each) do
          login_user(user)
          post :create, video_id: video.id, review: info
        end

        it_behaves_like 'a video show page'
      end
    end # context when user signed in

    context 'when user not signed in' do
      it 'redirects to root path' do
        post :create, video_id: video.id, review: {}
        expect(response).to redirect_to root_path
      end
    end
  end # describe POST create
end
