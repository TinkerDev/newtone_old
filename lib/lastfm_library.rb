class LastfmLibrary
  def self.get_lastfm_session
    lastfm_session = Lastfm.new(Settings.lastfm.key, Settings.lastfm.key)
    token = lastfm_session.auth.get_token
    #lastfm.session = lastfm.auth.get_session(:token => token)['key']
    lastfm_session
  end

  def self.get_chart_top_artists
    self.get_lastfm_session.chart.get_top_artists(:limit=>10000).map{|x| {:name=>x['name'], :mbid=>x['mbid']}}
  end

  #def self.search_for_artist name
  #  result = self.get_lastfm.artist.search(:artist => name)
  #  result.try{|x| x['results']}.try{|x| x['artistmatches']}.try{|x| x['artist']} || []
  #end

  def self.get_chart_top_tracks
    self.get_lastfm_session.chart.get_top_tracks(:limit=>30)
  end

end