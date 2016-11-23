require "rails_helper"

RSpec.describe "Bucketlists", type: :request do
  before do
    FactoryGirl.create :user
    create_bucketlist
  end

  describe "POST /api/v1/bucketlists" do
    context "with authorization header" do
      context "with valid bucketlist parameters" do
        it "creates a new bucketlist" do
          expect(response).to have_http_status(:success)
          expect(Bucketlist.count).to eq 1
          expect(json_response[:name]).to eq "2016 goals"
          expect(json_response[:created_by]).to eq "mayowa"
        end
      end

      context "with invalid bucketlist parameters" do
        it "fails to create a new bucketlist" do
          post bucketlists_path, { name: nil}, authorization_header(1)
          expect(Bucketlist.count).to eq 1
        end
      end
    end

    context "with no valid authorization header" do
      it "returns unauthorized error" do
        post bucketlists_path, FactoryGirl.attributes_for(:bucketlist)
        expect(response).to have_http_status(:unauthorized)
        expect(Bucketlist.count).to eq 1
        expect(json_response[:name]).to_not eq "2016 goals"
        expect(json_response[:error]).to eq "You are not authorized!"
      end
    end
  end

  describe "GET /api/v1/bucketlists" do
    context "with authorization header" do
      before do
        5.times { FactoryGirl.create(:bucketlist, :bucketlist2) }
        99.times { create_bucketlist }
      end

      context "with no pagination params" do
        it "defaults and returns only the user's first 20 bucketlists" do
          get bucketlists_path, {}, authorization_header(1)
          expect(response).to have_http_status(:success)
          expect(json_response.first[:name]).to eq "2016 goals"
          expect(Bucketlist.count).to eq 105
          expect(json_response.count).to eq 20
          expect(json_response.first[:id]).to eq 1
          expect(json_response.last[:id]).to eq 20
        end
      end

      context "with invalid pagination params" do
        it "defaults and returns only the user's first 20 bucketlists" do
          get bucketlists_path, { page: -1, limit: -3 }, authorization_header(1)
          expect(response).to have_http_status(:success)
          expect(json_response.first[:name]).to eq "2016 goals"
          expect(Bucketlist.count).to eq 105
          expect(json_response.count).to eq 20
          expect(json_response.first[:id]).to eq 1
          expect(json_response.last[:id]).to eq 20
        end
      end

      context "with pagination params and limit < 101" do
        it "returns results limited by the pagination params" do
          get bucketlists_path, { page: 2, limit: 5 }, authorization_header(1)
          expect(response).to have_http_status(:success)
          expect(json_response.first[:name]).to eq "2017 parties"
          expect(json_response.second[:name]).to eq "2016 goals"
          expect(json_response.count).to eq 5
          expect(json_response.first[:id]).to eq 6
          expect(json_response.last[:id]).to eq 10
        end
      end

      context "with pagination params and limit > 100" do
        it "limits bucketlists returned to the first 100 on requested page" do
          get bucketlists_path, { page: 1, limit: 200 }, authorization_header(1)
          expect(response).to have_http_status(:success)
          expect(json_response.first[:name]).to eq "2016 goals"
          expect(json_response.count).to eq 100
          expect(json_response.first[:id]).to eq 1
          expect(json_response.last[:id]).to eq 100
        end
      end

      context "with pagination params and search params" do
        it "returns results limited by the pagination and search params" do
          get bucketlists_path, { limit: 4, q: "goa" }, authorization_header(1)
          expect(response).to have_http_status(:success)
          expect(json_response.first[:name]).to_not eq "2017 parties"
          expect(json_response.first[:name]).to eq "2016 goals"
          expect(json_response.count).to eq 4
          expect(json_response.first[:id]).to eq 1
        end
      end
    end

    context "with no valid authorization header" do
      it "returns unauthorized error" do
        get bucketlists_path
        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq "You are not authorized!"
      end
    end
  end

  describe "GET /api/v1/bucketlists/1" do
    context "with authorization header" do
      it "renders the selected bucketlist" do
        get bucketlist_path, {}, authorization_header(1)
        expect(response).to have_http_status(:success)
        expect(json_response[:name]).to eq "2016 goals"
        expect(json_response[:id]).to eq 1
        expect(json_response[:id]).to eq Bucketlist.first.id
      end
    end

    context "with no valid authorization header" do
      it "returns unauthorized error" do
        get bucketlist_path
        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq "You are not authorized!"
      end
    end
  end

  describe "PUT /api/v1/bucketlists/1" do
    context "with authorization header" do
      context "with valid parameters" do
        it "updates selected bucketlist" do
          put bucketlist_path, { name: "ade" }, authorization_header(1)
          expect(response).to have_http_status(:success)
          expect(json_response[:name]).to eq "ade"
          expect(Bucketlist.first.name).to eq "ade"
          expect(json_response[:id]).to eq 1
          expect(json_response[:created_by]).to eq "mayowa"
        end
      end

      context "with invalid parameters" do
        it "fails to update selected bucketlist" do
          put bucketlist_path, { name: nil }, authorization_header(1)
          expect(Bucketlist.first.name).to eq "2016 goals"
        end
      end
    end

    context "with no valid authorization header" do
      it "returns unauthorized error" do
        put bucketlist_path
        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq "You are not authorized!"
      end
    end
  end

  describe "DELETE /api/v1/bucketlists/1" do
    context "with authorization header" do
      it "destroys the selected bucketlist" do
        delete bucketlist_path, {}, authorization_header(1)
        expect(response).to have_http_status(:success)
        expect(json_response[:name]).to eq nil
        expect(Bucketlist.count).to eq 0
        expect(json_response[:message]).to eq "Bucketlist has been deleted"
      end
    end

    context "with no valid authorization header" do
      it "returns unauthorized error" do
        delete bucketlist_path
        expect(response).to have_http_status(:unauthorized)
        expect(json_response[:error]).to eq "You are not authorized!"
      end
    end
  end
end
