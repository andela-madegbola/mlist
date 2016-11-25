require "rails_helper"

RSpec.describe "Auth", type: :request do
  before { FactoryGirl.create :user }

  describe "POST /auth/login" do
    context "with valid login credentials" do
      before { post auth_login_path, FactoryGirl.attributes_for(:user) }

      it "assigns a token to the user" do
        expect(response).to have_http_status(200)
        expect(json_response[:auth_token]).to_not eq nil
        expect(json_response[:message]).to include "Your token expires in 3 hours time"
      end

      it "creates token with valid user_id and serial_no key" do
        expect(decoded_token).to have_key :user_id
        expect(decoded_token[:user_id]).to eq User.first.id
        expect(decoded_token).to have_key :serial_no
        expect(decoded_token[:serial_no]).to eq User.first.serial_no
      end
    end

    context "with invalid login credentials" do
      it "refuses user authorization" do
        post auth_login_path, email: nil
        expect(response).to have_http_status(401)
        expect(json_response[:auth_token]).to eq nil
        expect(json_response[:error]).to eq "Invalid email or password!"
      end
    end
  end

  describe "GET /auth/logout" do
    context "with valid jwt token" do
      it "returns logout success message" do
        get auth_logout_path, {}, authorization_header(1)

        expect(response).to have_http_status(200)
        expect(json_response[:message]).
          to eq "You are now logged out!"
      end

      it "invalidates all active jwt tokens" do
        auth_header = authorization_header(1)

        get auth_logout_path, {}, auth_header

        invalid_token = JsonWebToken.decode(auth_header["Authorization"])
        expect(invalid_token[:user_id]).to eq User.first.id
        expect(invalid_token).to have_key :serial_no
        expect(invalid_token[:serial_no]).to_not eq User.first.serial_no
      end
    end

    context "with invalid jwt token" do
      it "returns not authorized error" do
        get auth_logout_path, {}, tampered_token

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq "You are not authorized!"
      end
    end

    context "with no jwt token" do
      it "returns not authorized error" do
        get auth_logout_path

        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq "You are not authorized!"
      end
    end
  end

  describe "prevent unauthorized use of valid tokens" do
    context "with valid token" do
      it "disallows access to other user's information" do
        create_bucketlist
        FactoryGirl.create(:user, :user2)

        get bucketlist_path, {}, authorization_header(2)

        expect(response).to have_http_status(:forbidden)
        expect(json_response[:error]).to eq "This bucketlist cannot be found"
      end
    end
  end
end