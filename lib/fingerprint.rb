class Fingerprint
  attr_reader :fingerprint, :compressed_data_string,
              :actual_data_string, :timestamps, :codes

  def initialize audio_file_path_or_fingerprint
    if audio_file_path_or_fingerprint.is_a? Hash
      @fingerprint = audio_file_path_or_fingerprint
    else
      @fingerprint = Newtone::Fingerprint.build audio_file_path_or_fingerprint
    end

    extract_compressed_data_string
    decompress_compressed_data_string
    parse_actual_data_string
  end

  def solr_string
    @codes.zip(@timestamps).flatten.join(' ')#.encode('utf-8')
  end

  def code
    @fingerprint["code"]
  end

  def metadata
    @fingerprint["metadata"]
  end

  [:artist, :title, :release, :genre, :version].each do |meta_info|
    define_method(meta_info) { metadata[meta_info.to_s] }
  end

  def duration
    metadata['duration'].to_i
  end

  def clean_codes_by_time
    #Remove all codes from a codes that are > 60 seconds in length.
    #Because we can only match 60 sec, everything else is unnecessary


    # If we use the codegen on a file with start/stop times, the first timestamp
    # is ~= the start time given. There might be a (slightly) earlier timestamp
    # in another band, but this is good enough
=begin
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
=end
  end

  private

  def extract_compressed_data_string
    @compressed_data_string = @fingerprint['code'].encode("utf-8")
  end

  def decompress_compressed_data_string
    return "" if @compressed_data_string.blank?
    @actual_data_string = Zlib::Inflate.inflate(Base64.urlsafe_decode64(@compressed_data_string))
  end

  def parse_actual_data_string
    if @actual_data_string.nil?
      raise FingerprintError, 'actual string is nil'
    end
    # Takes an uncompressed data string consisting of 0-padded fixed-width
    # sorted hex and converts it to the standard code string."""
    n = (@actual_data_string.length / 10.0).to_i

    end_timestamps_position = n*5  # 5 hex bytes for hash, 5 hex bytes for time (40 bits)
                                   # Parse out n groups of 5 timestamps in hex; then n groups of 8 hash codes in hex.
    raw_timestamps = @actual_data_string[0...end_timestamps_position]
    raw_codes = @actual_data_string[end_timestamps_position..-1]

    @timestamps = chunker(raw_timestamps, 5).map{|el| el.join('').to_i(16)}
    @codes = chunker(raw_codes, 5).map{|el| el.join('').to_i(16)}
  end

  def chunker(seq, size)
    seq.split('').each_slice(size).to_a
  end

end