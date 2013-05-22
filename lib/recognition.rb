class Recognition
  def self.recognize audio_file_path
    fingerprint = Fingerprint.new audio_file_path
    self.recognize_fingerprint(fingerprint)
  end

  def self.recognize_by_code code
    fingerprint = Fingerprint.new nil, code
    self.recognize_fingerprint(fingerprint)
  end

  def self.recognize_fingerprint fingerprint
    #Track.tire.search(array:fingerprint.term_string).results
    Track.tire.search do
      query do
        terms :terms, fingerprint.terms
      end
    end
  end
end