require "application_system_test_case"

class SpotifiesTest < ApplicationSystemTestCase
  setup do
    @spotify = spotifies(:one)
  end

  test "visiting the index" do
    visit spotifies_url
    assert_selector "h1", text: "Spotifies"
  end

  test "should create spotify" do
    visit spotifies_url
    click_on "New spotify"

    click_on "Create Spotify"

    assert_text "Spotify was successfully created"
    click_on "Back"
  end

  test "should update Spotify" do
    visit spotify_url(@spotify)
    click_on "Edit this spotify", match: :first

    click_on "Update Spotify"

    assert_text "Spotify was successfully updated"
    click_on "Back"
  end

  test "should destroy Spotify" do
    visit spotify_url(@spotify)
    click_on "Destroy this spotify", match: :first

    assert_text "Spotify was successfully destroyed"
  end
end
