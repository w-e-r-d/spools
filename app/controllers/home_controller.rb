class HomeController < ApplicationController
  # ----- details -----
  def details
    Rails.logger.info "Details Called"

    dummy = Dummy.first
    @spotify_user = RSpotify::User.new(dummy.spotify_hash)

    @playlists = fetch_all_playlists(@spotify_user)
    @playlist_options =
      @playlists
        .map { |pl| ["#{pl.name} — #{pl.owner&.display_name || pl.owner&.id}", pl.id] }
        .sort_by { |(label, _)| label.downcase }
  end

  # ----- reverse_playlist spool -----
  def reverse_playlist
    dummy = Dummy.first
    @spotify_user = RSpotify::User.new(dummy.spotify_hash)

    # combobox
    raw_text   = params.dig(:playlist, :uri_or_url).presence
    select_id  = params.dig(:playlist, :playlist_id).presence

    # parse id else fallback to selected
    playlist_id = extract_playlist_id(raw_text) || select_id
    unless playlist_id
      redirect_to home_details_path, alert: "Please choose a playlist or paste a valid Spotify URL/URI."
      return
    end

    # find among user playlists
    playlist = find_user_playlist(@spotify_user, playlist_id)

    # fallback to direct lookup
    if playlist.nil?
      begin
        playlist = RSpotify::Playlist.find(playlist_id)
      rescue => _
        playlist = nil
      end
    end

    unless playlist
      redirect_to home_details_path, alert: "Playlist not found or not accessible."
      return
    end

    Rails.logger.info "Reversing playlist: #{playlist.name} (#{playlist.id})"

    tracks = fetch_all_tracks(playlist)
    begin
      playlist.replace_tracks!(tracks.reverse)
      redirect_to home_details_path, notice: "Reversed “#{playlist.name}” (#{tracks.size} tracks)."
    rescue => e
      redirect_to home_details_path, alert: "Couldn't reverse “#{playlist.name}”: #{e.message}"
    end
  end

  private

  def fetch_all_playlists(user)
    all = []
    limit = 50
    offset = 0
    loop do
      batch = user.playlists(limit: limit, offset: offset)
      break if batch.nil? || batch.empty?
      all.concat(batch)
      break if batch.size < limit
      offset += limit
    end
    all
  end

  def fetch_all_tracks(playlist)
    all = []
    limit = 100
    offset = 0
    loop do
      batch = playlist.tracks(limit: limit, offset: offset)
      break if batch.nil? || batch.empty?
      all.concat(batch)
      break if batch.size < limit
      offset += limit
    end
    all
  end

  def find_user_playlist(user, playlist_id)
    limit = 50
    offset = 0
    loop do
      batch = user.playlists(limit: limit, offset: offset)
      break if batch.nil? || batch.empty?
      found = batch.find { |pl| pl.id == playlist_id }
      return found if found
      break if batch.size < limit
      offset += limit
    end
    nil
  end

  def extract_playlist_id(str)
    return nil if str.blank?
    s = str.strip

    # id
    return s if /\A[0-9A-Za-z]{22}\z/.match?(s)

    # url
    if s.include?("open.spotify.com/playlist/")
      return s.split("playlist/").last.split(/[?\s]/).first
    end

    # uri
    if s.start_with?("spotify:playlist:")
      return s.split(":").last
    end

    nil
  end
end
