module ApplicationHelper
  
  def fontello icon, size = '', custom_class = ''
    #icon = case icon
    #  when 'wants' || 'want' || 'get' || 'wanted_items' then 'star'
    #  else icon
    #end
    content_tag :i, '', :class => "fontello-icon-#{icon} icon-size-#{size} #{custom_class}"
  end

  def newtone_face mood
    image_tag image_path("newtone/newtone_#{mood}.png"), :class => "newtone-face newtone-#{mood}"
  end
  
  def social_button name
    name = name.to_s
    path = name

    path = 'google_oauth2' if path == 'google'
    link_to social_button_title(name).html_safe, user_omniauth_authorize_path(path),
      :class => "social-login-button social-login-button-#{name} v-align-baseline"
  end

  def social_button_title name, scope = :socials
    fontello(name, 28, 'v-align-baseline') << '&nbsp;&nbsp;'.html_safe << t(name, :scope => scope)
  end



end
