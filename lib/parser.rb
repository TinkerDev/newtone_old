class Parser
  def self.test

    #s1 = ''
    #s2 = ''

    #app = VK::Application.new access_token: VkToken.get_token
    #app.audio.search :q=>'gaga'


    session = ::VkApi::Session.new(Settings.vk.app_id, Settings.vk.app_secret)
    session.audio.search :q => 'gaga', :access_token => VkToken.get_token

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

  def self.get_token
    model = VkToken.first
    if model.nil? or model.expires_at <= Time.now
      model = VkToken.create_new_token
    end
    model.access_token
  end

  def self.get_new_artist


end