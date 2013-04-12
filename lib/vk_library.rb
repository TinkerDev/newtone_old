class VkLibrary
  def self.get_token
    model = VkToken.first
    if model.nil? or model.expires_at <= Time.now
      model = VkToken.create_new_token
    end
    model.access_token
  end

  def self.find_track artist, title, duration
    session = ::VkApi::Session.new(Settings.vk.app_id, Settings.vk.app_secret)
    tracks = session.audio.search(:q => "#{artist} #{title}", :access_token => self.get_token)
    tracks.shift
    track = tracks.find{|el| el['duration'] == duration }
    unless track
      [1,2].each do |dp|
        track = tracks.find{|el| el['duration'] == duration + dp }
        break if track
      end
      [1,2].each do |dp|
        track = tracks.find{|el| el['duration'] == duration - dp }
        break if track
      end
    end
    track
  end

end