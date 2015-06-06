require 'spec_helper'
require 'shared_examples'

describe VideosController do
  describe "GET show" do
    let(:south_park) { Fabricate(:video, title: "South Park") }
    let(:reviews) { Fabricate.times(3, :review, video: south_park) }

    context 'when user signed in' do
      before(:each) do
        login_user
        get :show, id: south_park.id
      end
      it_behaves_like 'a video show page'
    end

    context 'when user is not signed in' do
      it 'redirect to root path' do
        get :show, id: south_park.id
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
        south_park = Fabricate(:video, title: "South Park")
        get :search, q: "South Park"

        expect(assigns(:search_results)).to eq([south_park])
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
