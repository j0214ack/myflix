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
  end
end
