module HomeHelper

  def playlists_for_select(spotify_user)
    spotify_user.playlists.map { |pl| [pl.name, pl.id] }
  end
end

