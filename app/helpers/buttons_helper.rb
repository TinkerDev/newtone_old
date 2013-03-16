module ButtonsHelper
  def audio_button type, state = ''
    css_class = "audio-button-icon audio-button-#{type}"
    button = ''
    case type
      when :record
        button = fontello 'mic', '', css_class
      when :upload
        button = fontello 'upload', '', css_class
    end
    content_tag :li, :class => "audio-button #{state}" do
      link_to button, "##{type}", 'data-toggle' => 'tab'
    end
  end

end
