require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    context "when user is signed in" do
      before(:each) do
        login_user
        get :new
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

      it "sets flash error message" do
        expect(flash[:error]).to be_present
      end
    end

    context "when user is not signed in" do
      it "renders the sign in page" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user) }

    context "when already signed in" do
      before(:each) do
         login_user
         post :create
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

      it "set flash error" do
        expect(flash[:error]).to be_present
      end
    end

    context "when provided with valid information" do
      let(:information) do
        { email: user.email,
          password: user.password }
      end
      before(:each) { post :create, information }

      it "sets session[:user_id] to the correct user.id" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home path" do
        expect(response).to redirect_to home_path
      end

      it "sets flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "when provided with invalid information" do
      let(:information) do
        { email: user.email,
          password: user.password + "wrong!" }
      end

      it "renders the sign in page" do
        post :create

        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE destroy" do
    context "when user is signed in" do
      before(:each) do
        login_user
        delete :destroy
      end

      it "session[:user_id] is set to nil" do
        expect(session[:user_id]).to be_nil
      end

      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end

      it "sets flash[:success] message" do
        expect(flash[:success]).to be_present
      end
    end

    context "when user is not signed in" do
      before(:each) { delete :destroy }
      it "redirects to root_path" do
        expect(response).to redirect_to root_path
      end

      it "sets flash[:error]" do
        expect(flash[:error]).to be_present
      end
    end
  end
end
