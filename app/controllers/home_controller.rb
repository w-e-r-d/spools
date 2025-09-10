class HomeController < ApplicationController
  def index
    puts "Home Index - Chris was here"

    artists = RSpotify::Artist.search('Arctic Monkeys')

    pp artists

    arctic_monkeys = artists.first
    pp arctic_monkeys.popularity #=> 74
    pp arctic_monkeys.genres #=> ["Alternative Pop/Rock", "Indie", ...]
    pp arctic_monkeys.top_tracks(:US) #=> (Track array)

  end

  def details
    pp "Details Called"
    dummy = Dummy.first

    @spotify_user = RSpotify::User.new(dummy.spotify_hash)

    # spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # pp spotify_user

  end

  def reverse_playlist

    dummy = Dummy.first

    @spotify_user = RSpotify::User.new(dummy.spotify_hash)

    pp @spotify_user

    @playlist = @spotify_user.playlists.detect { |pl| pl.id == params[:playlist][:playlist_id] }

    raise "Playlist not found for this user" unless @playlist

    pp "Doing something with a selected playlist: #{@playlist.name}"

    @playlist.replace_tracks!(@playlist.tracks.reverse)
  end

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    # Now you can access user's private data, create playlists and much more

    dummy = Dummy.first
    dummy.spotify_hash = spotify_user.to_hash
    dummy.save!

    return

    # Access private data
    spotify_user.country #=> "US"
    spotify_user.email #=> "example@email.com"

    # Create playlist in user's Spotify account
    playlist = spotify_user.create_playlist!('my-awesome-playlist')

    # Add tracks to a playlist in user's Spotify account
    tracks = RSpotify::Track.search('Know')
    playlist.add_tracks!(tracks)
    playlist.tracks.first.name #=> "Somebody That I Used To Know"

    # Access and modify user's music library
    spotify_user.save_tracks!(tracks)
    spotify_user.saved_tracks.size #=> 20
    spotify_user.remove_tracks!(tracks)

    albums = RSpotify::Album.search('launeddas')
    spotify_user.save_albums!(albums)
    spotify_user.saved_albums.size #=> 10
    spotify_user.remove_albums!(albums)

    # Use Spotify Follow features
    # spotify_user.follow(playlist)
    # spotify_user.follows?(artists)
    # spotify_user.unfollow(users)

    # Get user's top played artists and tracks
    # spotify_user.top_artists #=> (Artist array)
    # spotify_user.top_tracks(time_range: 'short_term') #=> (Track array)

    # Check doc for more
  end

end
