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
  end # describe POST create

  describe 'DELETE destroy' do
    # For redirect_to :back funtionality in controller
    before(:each) { request.env["HTTP_REFERER"] = "http://test.host" }

    context 'when user not signed in,' do
      let(:queue_item) { Fabricate(:queue_item) }
      it 'redirects to root path' do
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to root_path
      end
      it 'sets flash[:error]' do
        delete :destroy, id: queue_item.id
        expect(flash[:error]).to be_present
      end
    end

    context 'when user signed in,' do
      let(:user) { Fabricate(:user) }
      before(:each) { login_user(user) }

      context 'when the queue item belongs to the user,' do
        let!(:queue_item) { Fabricate(:queue_item, user: user) }

        it 'deletes the queue item' do
          expect {
            delete :destroy, id: queue_item.id
          }.to change{QueueItem.count}.by(-1)
        end

        it 'redirects to the previous path' do
          delete :destroy, id: queue_item.id
          expect(response).to redirect_to :back
        end

        it "normalizes the queue items' position" do
          user2 = Fabricate(:user)
          login_user(user2)
          queue_items = Fabricate.times(3, :queue_item, user: user2)
          delete :destroy, id: queue_items[1].id

          expect(user2.queue_items.map(&:position)).to eq [1,2]
        end
      end

      context "when the queue item doesn't belongs to the user" do
        let!(:queue_item) { Fabricate(:queue_item) }

        it "doesn't delete the queue item" do
          expect {
            delete :destroy, id: queue_item.id
          }.not_to change{QueueItem.count}
        end

        it 'redirects to the previous path' do
          delete :destroy, id: queue_item.id
          expect(response).to redirect_to :back
        end

        it 'sets flash[:error]' do
          delete :destroy, id: queue_item.id
          expect(flash[:error]).to be_present
        end
      end
    end # context when user signed in
  end # describe DELETE destroy

  describe 'PUT batch_update' do
    context 'when user not signed in' do
      it 'redirects to root path' do
        put 'batch_update', queue_items: []

        expect(response).to redirect_to root_path
      end
    end

    context 'when user signed in' do
      let(:user) { Fabricate(:user) }
      before { login_user(user) }
      context 'when all the position parameters are valid, ' do
        it 'updates the position of each queue item' do
          queue_item1 = Fabricate(:queue_item, user: user)
          queue_item2 = Fabricate(:queue_item, user: user)

          put 'batch_update', queue_items: [
                                {id: queue_item1.id, position: 2},
                                {id: queue_item2.id, position: 1}
                              ]

          updated_positions = [ queue_item1.reload.position,
                                queue_item2.reload.position ]

          expect(updated_positions).to eq [2,1]
        end

        it 'normalizes the positions' do
          queue_item1 = Fabricate(:queue_item, user: user)
          queue_item2 = Fabricate(:queue_item, user: user)

          put 'batch_update', queue_items: [
                                { id: queue_item1.id, position: 9},
                                { id: queue_item2.id, position: 3}
                              ]
          updated_positions = [ queue_item1.reload.position,
                                queue_item2.reload.position ]

          expect(updated_positions).to eq [2,1]
        end

        it 'redirects to my queue path' do
          put 'batch_update', queue_items: []
          expect(response).to redirect_to my_queue_path
        end
      end

      context 'when some of the position parameters is duplicated' do
        it 'does not update queue items at all' do
          queue_items = Fabricate.times(3, :queue_item, user: user)

          put 'batch_update', queue_items: [
                                { id: queue_items[0].id, position: 2 },
                                { id: queue_items[1].id, position: 1 },
                                { id: queue_items[2].id, position: 2 }
                              ]

          expect(user.queue_items).to eq queue_items
        end

        it 'sets flash[:error]' do
          queue_items = Fabricate.times(3, :queue_item, user: user)

          put 'batch_update', queue_items: [
                                { id: queue_items[0].id, position: 2 },
                                { id: queue_items[1].id, position: 1 },
                                { id: queue_items[2].id, position: 2 }
                              ]

          expect(flash[:error]).to be_present
        end
      end # context when at least one of the position parameters is invalid

      context 'when some of the position value is not valid' do
        it 'does not update queue items at all' do
          queue_items = Fabricate.times(3, :queue_item, user: user)

          put 'batch_update', queue_items: [
                                { id: queue_items[0].id, position: 1 },
                                { id: queue_items[1].id, position: 'wrong' },
                                { id: queue_items[2].id, position: 3 }
                              ]

          expect(user.queue_items).to eq queue_items
        end

        it 'sets flash[:error]' do
          queue_items = Fabricate.times(3, :queue_item, user: user)

          put 'batch_update', queue_items: [
                                { id: queue_items[0].id, position: 1 },
                                { id: queue_items[1].id, position: 'wrong' },
                                { id: queue_items[2].id, position: 3 }
                              ]

          expect(flash[:error]).to be_present
        end
      end # context when some of the position value is not valid

      context "when tries to update other user's item" do
        it 'does not update' do
          other_user = Fabricate(:user)
          other_items = Fabricate.times(3, :queue_item, user: other_user)

          put 'batch_update', queue_items: [
                                { id: other_items[0].id, position: 3},
                                { id: other_items[1].id, position: 2},
                                { id: other_items[2].id, position: 1},
                              ]

          expect(other_user.queue_items).to eq(other_items)
        end

        it 'sets flash[:error]' do
          other_user = Fabricate(:user)
          other_items = Fabricate.times(3, :queue_item, user: other_user)

          put 'batch_update', queue_items: [
                                { id: other_items[0].id, position: 3},
                                { id: other_items[1].id, position: 2},
                                { id: other_items[2].id, position: 1},
                              ]

          expect(flash[:error]).to be_present
        end
      end

    end # context when user signed in
  end # describe PUT batch_update
end
