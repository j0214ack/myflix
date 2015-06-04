require 'spec_helper'

def login_user
  user = User.find_by(email: "a@example.com")
  user ||= User.create(email: "a@example.com", password: "abc", full_name: "CY C")
  request.session[:user_id] = user.id
end

describe VideosController do

  describe "GET show" do

    it "sets @video variable" do
      login_user
      south_park = Video.create(title: "South Park", description: "Stain, Eric")
      get :show, id: south_park.id
      expect(assigns(:video)).to eq(south_park)
    end

    it "renders videos/show template" do
      login_user
      south_park = Video.create(title: "South Park", description: "Stain, Eric")
      get :show, id: south_park.id

      expect(response).to render_template :show
    end

  end

  describe "GET search" do

    it "sets @search_value variable from parameter" do
      login_user
      get :search, q: "South Park"

      expect(assigns(:search_value)).to eq("South Park")
    end

    it "renders search template" do
      login_user
      get :search, q: "South Park"

      expect(response).to render_template :search
    end

    describe "@search_results" do
      context "query no match" do
        it "is set to []" do
          login_user
          monk = Video.create(title: "Monk", description: "Monk")
          get :search, q: "South Park"
          expect(assigns(:search_results)).to eq([])
        end
      end

      context "query matched only one video" do
        it "is an array containing one element" do
          login_user
          monk = Video.create(title: "Monk", description: "Monk")
          get :search, q: "monk"
          expect(assigns(:search_results)).to eq([monk])
        end
      end

      context "query matched three videos" do
        it "is an array containing all three videos" do
          login_user
          monk = Video.create(title: "Monk", description: "Monk")
          monk2 = Video.create(title: "Monk 2", description: "Monk")
          monk3 = Video.create(title: "Monk 3", description: "Monk")
          get :search, q: "monk"
          expect(assigns(:search_results)).to include(monk, monk2, monk3)
          expect(assigns(:search_results).size).to eq(3)
        end

        it "returns the three matched videos in descending order of created_at" do
          login_user
          monk = Video.create(title: "Monk", description: "Monk")
          monk2 = Video.create(title: "Monk 2", description: "Monk")
          monk3 = Video.create(title: "Monk 3", description: "Monk")
          get :search, q: "monk"
          expect(assigns(:search_results)).to eq([monk, monk2, monk3].reverse)
        end
      end

      context "query is empty string" do
        it "is an empty array" do
          login_user
          monk = Video.create(title: "Monk", description: "Monk")
          get :search, q: ""
          expect(assigns(:search_results)).to eq([])
        end
      end

      context "query is nil" do
        it "is an empty array" do
          login_user
          monk = Video.create(title: "Monk", description: "Monk")
          get :search, q: nil
          expect(assigns(:search_results)).to eq([])
        end
      end
    end

  end
end
