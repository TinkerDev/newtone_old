module ButtonsHelper
  def select_audio_source_button type, state = ''
    css_class = "audio-button-icon audio-button-#{type}"
    button = ''
    case type
      when :record
        button = content_tag(:div, "#{fontello('mic', '', css_class)}".html_safe, :class => 'audio-source-button-link')
        tooltip = content_tag(:div, I18n.t('audio_sources.record_sample'), :class => 'audio-source-button-caption')
      when :upload
        button = content_tag(:div, "#{fontello('upload', '', css_class)}".html_safe, :class => 'audio-source-button-link')
        tooltip = content_tag(:div, I18n.t('audio_sources.upload_file'), :class => 'audio-source-button-caption')
      when :new
        button = content_tag(:div, "#{fontello('cw', '', css_class)}".html_safe, :class => 'round-link')
        tooltip = content_tag(:div, I18n.t('recognize_new_track'), :class => 'audio-source-button-caption center-block')
        return link_to_function("#{button} #{tooltip}".html_safe, "screenState('welcome'); newtoneFace('normal');")
    end
    content_tag :li, :class => "audio-button #{state}" do
      link_to( "#{button} #{tooltip}".html_safe, "##{type}", 'data-toggle' => 'tab', :id=>"audio-button-#{type}")
    end
  end

  def spinner
    content_tag(:div, :class => 'ui-spinner') do
      content_tag(:span, content_tag(:span, '', :class => 'fill'), :class => 'side side-left') + content_tag(:span, content_tag(:span, '', :class => 'fill'), :class => 'side side-right')
    end
  end

end
