module ButtonsHelper
  def audio_button type, state = ''
    css_class = "audio-button-icon audio-button-#{type}"
    button = ''
    case type
      when :record
        button = fontello 'mic', '', css_class
        tooltip = 'record sample to recognize'
      when :upload
        button = fontello 'upload', '', css_class
        tooltip = 'upload file to recognize'
    end
    content_tag :li, :class => "audio-button #{state}" do
      link_to button, "##{type}", 'data-toggle' => 'tab', :rel => "tooltip", 'data-original-title' => tooltip 
    end
  end

  def spinner
    content_tag(:div, :class => 'ui-spinner') do
      content_tag(:span, content_tag(:span, '', :class => 'fill'), :class => 'side side-left') + content_tag(:span, content_tag(:span, '', :class => 'fill'), :class => 'side side-right')
    end
  end

end
