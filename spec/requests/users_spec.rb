require "rails_helper"

RSpec.describe "Users", type: :request do
  before { FactoryGirl.create :user }

  describe "POST /users" do
    context "when a user enters valid parameters" do
      it "should create a new user" do
        post users_path, FactoryGirl.attributes_for(:user, :user2)

        expect(response).to have_http_status(:success)
        expect(User.count).to eq 2
        expect(json_response[:username]).to eq "mj"
        expect(json_response[:email]).to eq "mj@gmail.com"
      end
    end

    context "when a user enters invalid parameters" do
      it "should fail to create a new user" do
        post users_path, username: nil

        expect(response).to have_http_status(400)
        expect(User.count).to eq 1
        expect(json_response[:username]).to eq nil
        expect(json_response[:error]).to eq "User not created"
      end
    end
  end

  describe "DELETE /users/1" do
    it "destroys the selected user" do
      delete user_path(1), {}, authorization_header(1)

      expect(response).to have_http_status(:success)
      expect(json_response[:username]).to eq nil
      expect(User.count).to eq 0
    end
  end
end