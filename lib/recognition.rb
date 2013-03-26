class Recognition

  def initialize audio_file_path
    @audio_file_path = audio_file_path
  end

  def recognize elbow=10
    @fingerprint = Fingerprint.new @audio_file_path
    #clean_codes_by_time
    Solr.search @fingerprint.solr_string
    #solr_final_string
  end

  def friendly_recognize elbow=10
    response = recognize['response']
    Solr.human_response response
  end

  private

  def clean_codes_by_time
    #Remove all codes from a codes that are > 60 seconds in length.
    #Because we can only match 60 sec, everything else is unnecessary


    # If we use the codegen on a file with start/stop times, the first timestamp
    # is ~= the start time given. There might be a (slightly) earlier timestamp
    # in another band, but this is good enough
    first_timestamp = @timestamps[1]

    sixty_seconds = (60.0 * 1000.0 / 23.2 + first_timestamp).to_i
    timestamps = codes = []

    @timestamps.each_with_index do |timestamp, index|
      if timestamp <= sixty_seconds
        timestamps << timestamp
        codes << index
      end
    end

    @timestamps, @codes = timestamps, codes
    @codes
  end

end