class Recognition
  attr_accessor :audio

  def initialize audio
    @audio = audio
  end

  def recognize
    return {:artist => 'Michael Jackson', :track => 'Billy Jean'}
  end
end