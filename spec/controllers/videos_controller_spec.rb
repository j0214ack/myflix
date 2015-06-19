require 'spec_helper'

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

    it_behaves_like 'require user signed in' do
      let(:action) { get :show, id: video.id }
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

    it_behaves_like 'require user signed in' do
      let(:action) { get :search, q: "South Park" }
    end
  end
end
