require 'spec_helper'
require 'shared_examples'

describe VideosController do
  describe "GET show" do
    let(:video) { Fabricate(:video, title: "South Park") }
    let(:reviews) { Fabricate.times(3, :review, video: video) }

    context 'when user signed in' do
      before(:each) do
        login_user
        get :show, id: video.id
      end
      it_behaves_like 'a video show page'
    end

    context 'when user is not signed in' do
      it 'redirect to root path' do
        get :show, id: video.id
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'GET search' do
    context 'when user is authenticated' do
      before(:each) { login_user }

      it 'sets @search_value variable from parameter' do
        get :search, q: 'South Park'

        expect(assigns(:search_value)).to eq("South Park")
      end

      it "sets @search_results" do
        video = Fabricate(:video, title: "South Park")
        get :search, q: "South Park"

        expect(assigns(:search_results)).to eq([video])
      end
    end

    context "when user is not authenticated" do
      it "redirects to root path" do
        get :search, q: "South Park"

        expect(response).to redirect_to root_path
      end
    end
  end
end
