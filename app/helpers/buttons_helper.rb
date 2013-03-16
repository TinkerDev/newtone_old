module ButtonsHelper
  def audio_button type
    css_class = "audio-button-icon audio-button-#{type}"
    button = ''
    case type
      when :record
        button = fontello 'mic', '', css_class << "active"
      when :upload
        button = fontello 'upload', '', css_class
    end
    content_tag(:div, button, :class => 'btn btn-large audio-button')
  end

  def audio_buttons
    content_tag(:div, audio_button(:record) << audio_button(:upload), :class => 'btn-group audio-buttons')
  end

end
