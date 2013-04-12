class Parser
  def self.test

    #s1 = ''
    #s2 = ''

    #app = VK::Application.new access_token: VkToken.get_token
    #app.audio.search :q=>'gaga'




    #session = ::VkApi::Session.new s1, s2
    #require 'open-uri'
    #x =
    #x = 'http://vk.com'
    #x ='https://oauth.vk.com/access_token?client_id=' + s1 + '&client_secret=' + s2 + '&grant_type=client_credentials'
    #token = JSON.parse(open(x).read)['access_token']
    #session.audio.search :q => 'gagga', :access_token => token
    #session.get_user_settings
    #x = 'https://api.vk.com/method/searchUsers?q=Gaga&access_token='+token
    #JSON.parse(open(x).read)
    #open(x).read

  end

  def self.merge_artists_from_lastfm_chart_top_artist
    artists = LastfmLibrary.get_chart_top_artists
    artists.map{|a| artist = Artist.find_or_create_by_name(a[:name]); artist.update_attribute(:mbid, a[:mbid]) }
  end

  def self.merge_tracks_from_lastfm_chart_top_tracks
    tracks = LastfmLibrary.get_chart_top_tracks

    tracks = tracks.inject([]) do |res, t|
      artist = t['artist']
      artist = Artist.find_or_create_by_name(artist['name'])
      artist.update_attribute(:mbid, artist['mbid'])
      if t['duration'].is_a? String
        res << {:title=>t['name'], :artist=>artist, :duration=>(t['duration'].to_i) }
      end
      res
    end

    tracks.inject([]) do |res, track|
      vk_track = VkLibrary.find_track(track[:artist].name, track[:title], track[:duration])
      if vk_track
        res << Track.create(:title => track[:title], :artist => track[:artist], :remote_track_file_url => vk_track['url'])
      end
      res
    end

  end

end