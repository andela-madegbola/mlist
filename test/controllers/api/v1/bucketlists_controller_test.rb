require 'test_helper'

class Api::V1::BucketlistsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_bucketlists_index_url
    assert_response :success
  end

end
