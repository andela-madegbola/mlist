require "rails_helper"

RSpec.describe Bucketlist, type: :model do
  it { is_expected.to have_many(:items) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:name) }

  describe ".search" do
    it "responds to search method" do
      expect(Bucketlist).to respond_to(:search)
    end

    it "returns the appropriate search query" do
      bucketlist2 = FactoryGirl.create(:bucketlist, :bucketlist2)
      5.times { FactoryGirl.create :bucketlist }
      expect(Bucketlist.count).to eq 6
      bucketlist2_search = Bucketlist.search("2017")
      expect(bucketlist2_search.count).to eq 1
      expect(bucketlist2_search.first.name).to eq bucketlist2.name
      expect(bucketlist2_search.first.name).to eq "2017 parties"
    end
  end
end