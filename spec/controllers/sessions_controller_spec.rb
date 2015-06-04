require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    context "when user is signed in" do
      it "redirects to home path" do
        login_user

        get :new
        expect(response).to redirect_to home_path
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
    context "when provided with valid information" do
      let(:user) { Fabricate(:user) } #default password is "password"
      let(:information) do
        { email: user.email,
          password: "password" }
      end

      it "sets session[:user_id] to the correct user.id" do
        post :create, information
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home path" do
        post :create, information
        expect(response).to redirect_to home_path
      end
    end

    context "when provided with invalid information" do
      it "renders the sign in page" do
        post :create

        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE destroy" do
    it "session[:user_id] is set to nil" do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end
    it "redirects to root_path" do
      delete :destroy
      expect(response).to redirect_to root_path
    end
  end
end
