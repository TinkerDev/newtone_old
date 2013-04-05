class LastParser
  def self.get_lastfm
    lastfm = Lastfm.new(Settings.lastfm.key, Settings.lastfm.key)
    token = lastfm.auth.get_token
    #lastfm.session = lastfm.auth.get_session(:token => token)['key']
    lastfm
  end

  def self.merge_top_artists
    self.get_lastfm.chart.get_top_artists(:limit=>10000).map{|x| Artist.find_or_create_by_name(x['name'])}
  end
end