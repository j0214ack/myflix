require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets a new @user variable" do
      get :new
      expect(assigns(:user)).to be_new_record
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "when provided with valid parameters" do
      let(:user_param) { { user: Fabricate.attributes_for(:user) } }

      it "redirects to root path" do
        post :create, user_param
        expect(response).to redirect_to root_path
      end

      it "creates the user record" do
        post :create, user_param

        user = User.find_by(email: user_param[:user][:email])
        expect(user).to be
      end

      it "signs in the user" do
        post :create, user_param

        user = User.find_by(email: user_param[:user][:email])
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context "when provided with invalid parameters" do
      it "renders new template" do
        post :create, user: { email: "" }
        expect(response).to render_template :new
      end
    end
  end
end
