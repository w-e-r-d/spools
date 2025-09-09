require "test_helper"

class SpotifiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @spotify = spotifies(:one)
  end

  test "should get index" do
    get spotifies_url
    assert_response :success
  end

  test "should get new" do
    get new_spotify_url
    assert_response :success
  end

  test "should create spotify" do
    assert_difference("Spotify.count") do
      post spotifies_url, params: { spotify: {} }
    end

    assert_redirected_to spotify_url(Spotify.last)
  end

  test "should show spotify" do
    get spotify_url(@spotify)
    assert_response :success
  end

  test "should get edit" do
    get edit_spotify_url(@spotify)
    assert_response :success
  end

  test "should update spotify" do
    patch spotify_url(@spotify), params: { spotify: {} }
    assert_redirected_to spotify_url(@spotify)
  end

  test "should destroy spotify" do
    assert_difference("Spotify.count", -1) do
      delete spotify_url(@spotify)
    end

    assert_redirected_to spotifies_url
  end
end
