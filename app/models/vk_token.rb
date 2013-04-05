class VkToken < ActiveRecord::Base
  attr_accessible :access_token, :expires_at
  def self.create_new_token
    VkToken.destroy_all("expires_at <= '#{Time.now.to_s(:db)}'")
    agent = Mechanize.new
    page = agent.get('http://vk.com')
    form = page.form
    form.email = Settings.vk.login
    form.pass = Settings.vk.pass
    page = agent.submit(form)
    token_url = 'https://api.vk.com/oauth/authorize?client_id=3546981&redirect_uri=https://api.vk.com/blank.html&scope=audio&display=page&response_type=token'
    page = agent.get(token_url)
    params = page.uri.fragment.split('&').inject({}){|res,x| key, value = x.split('=');res[key]=value;res;}
    access_token = params['access_token']
    expires_at = Time.now + ( params['expires_in'].to_i - 20 ).seconds
    VkToken.create(:access_token => access_token, :expires_at => expires_at)
  end
end
