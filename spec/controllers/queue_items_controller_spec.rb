require 'spec_helper'

describe QueueItemsController do
  describe 'GET index' do
    context 'when user signed in,' do
      let(:user) { Fabricate(:user) }
      before(:each) { login_user(user) }

      it "sets @queue_items variable to current user's queue items" do
        queue_item1 = Fabricate(:queue_item, user: user)
        queue_item2 = Fabricate(:queue_item, user: user)
        get 'index'
        expect(assigns(:queue_items)).to match_array([queue_item1,queue_item2])
      end

      it 'renders index template' do
        get 'index'
        expect(response).to render_template 'index'
      end
    end

    context 'when user not signed in,' do
      before(:each) { get 'index' }
      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
      it 'sets flash[:error] message' do
        expect(flash[:error]).to be_present
      end
    end
  end # describe GET index

  describe 'POST create' do
    context 'when user signed in,' do
      let(:user) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      before(:each) { login_user(user) }

      context "when video is already in user's queue," do
        before(:each) do
          Fabricate(:queue_item, video: video, user: user)
          post 'create', video_id: video.id
        end

        it 'redirects to the video page' do
          expect(response).to redirect_to video
        end

        it 'sets flash[:error]' do
          expect(flash[:error]).to be_present
        end
      end

      context "when video is not in user's queue," do
        before(:each) { post 'create', video_id: video.id }
        it 'creates the queue item' do
          expect(QueueItem.first).to be
        end

        it 'creates the queue item associated with the user' do
          expect(QueueItem.first.user).to eq user
        end

        it 'creates the queue item associated with the video' do
          expect(QueueItem.first.video).to eq video
        end

        it 'redirects to the video page' do
          expect(response).to redirect_to video_path(video)
        end
      end
    end

    context 'when user not signed in,' do
      it 'redirects to root path' do
        post :create
        expect(response).to redirect_to root_path
      end
    end
  end
end
