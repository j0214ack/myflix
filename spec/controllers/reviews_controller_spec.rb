require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'when user signed in' do
      let(:video) { Fabricate(:video) }
      before(:each) do
        login_user
      end

      context 'when provided with valid information' do
        let(:info) do
          Fabricate.attributes_for(:review, video: nil, user: nil)
        end
        before(:each) do
          post :create, video_id: video.id, review: info
        end

        it 'creates the review' do
          review = current_user.reviews.where(video: video).first
          expect(review).to be
        end

        it 'redirects to video page' do
          expect(response).to redirect_to video_path(video)
        end

        it 'sets flash[:success]' do
          expect(flash[:success]).to be_present
        end
      end # context when provided with valid information

      context 'when provided with invalid information' do
        before(:each) do
          post :create, video_id: video.id, review: { rating: 1, comment: '' }
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
