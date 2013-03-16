class Recognition
  attr_reader :audio_file_path, :raw_fingerprint, :raw_code

  def initialize audio_file_path
    @audio_file_path = audio_file_path
  end

  def make_raw_fingerprint
    @raw_fingerprint = Newtone::Fingerprint.build audio_file_path
    @raw_code = @raw_fingerprint['code']
  end

  def recognize
    self.make_raw_fingerprint
    return {:artist => 'Michael Jackson', :track => 'Billy Jean', :status => 1}
  end
end