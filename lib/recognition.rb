class Recognition
  attr_reader :audio_file_path, :raw_fingerprint, :compressed_data_string, :actual_data_string,
              :timestamps, :codes

  def initialize audio_file_path
    @audio_file_path = audio_file_path
  end


  def recognize elbow=10
    common_parse_flow
    #clean_codes_by_time
    do_solr_query
  end

  def friendly_recognize elbow=10
    response = recognize['response']
    SolrQuery.human_response response
  end

  def common_parse_flow
    make_raw_fingerprint
    extract_compressed_data_string
    decompress_compressed_data_string
    parse_actual_data_string
  end

  def solr_final_string
    @codes.zip(@timestamps).flatten.join(' ').encode('utf-8')
  end

  private

  def make_raw_fingerprint
    @raw_fingerprint = Newtone::Fingerprint.build audio_file_path
  end

  def extract_compressed_data_string
    @compressed_data_string = @raw_fingerprint['code'].encode("utf-8")
  end

  def decompress_compressed_data_string
    return "" if @compressed_data_string.blank?
    @actual_data_string = Zlib::Inflate.inflate(Base64.urlsafe_decode64(@compressed_data_string))
  end

  def parse_actual_data_string
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

  def do_solr_query
    SolrQuery.do_solr_query solr_final_string
  end

  def chunker(seq, size)
    seq.split('').each_slice(size).to_a
  end

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