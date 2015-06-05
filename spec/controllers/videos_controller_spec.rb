require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:south_park) { Fabricate(:video, title: "South Park") }
    let(:reviews) { Fabricate.times(3, :review, video: south_park) }

    context 'when user signed in' do
      before(:each) do
        login_user
        get :show, id: south_park.id
      end

      it "sets @video variable when user is authenticated" do
        expect(assigns(:video)).to eq(south_park)
      end

      it 'sets @reviews variable' do
        expect(assigns(:reviews)).to eq(reviews.sort_by(&:created_at).reverse)
      end

      it 'sets @review variable' do
        expect(assigns(:reviews)).to be_new_record
        expect(assigns(:reviews)).to be_instance_of Review
      end

      it 'sets @average_rating variable' do
        expect(assigns(:average_rating)).to be_instance_of Float
      end

      it 'sets @rating_chioces variable' do
        expect(assigns(:rating_chioces)).to be_instance_of Array
      end

    end

    context 'when user is not signed in' do
      it "redirect to root path" do
        get :show, id: south_park.id
        expect(response).to redirect_to root_path
      end
    end

  end

  describe "GET search" do
    context "when user is authenticated" do
      before(:each) { login_user }

      it "sets @search_value variable from parameter" do
        get :search, q: "South Park"

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
