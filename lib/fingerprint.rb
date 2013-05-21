class Fingerprint
  attr_reader :raw_fingerprint, :compressed_data_string,
              :decompressed_data_string, :offsets, :terms

  def initialize source, code = nil
    case source
      when Hash
        @raw_fingerprint = source
      when String
        @raw_fingerprint = Newtone::Fingerprint.build source
      else
        @raw_fingerprint = {}
        @raw_fingerprint['code'] = code
    end

    extract_compressed_data_string
    decompress_compressed_data_string
    parse_decompressed_data_string
  end

  def term_string
    #@terms.zip(@offsets).flatten.join(' ')#.encode('utf-8')
    @terms.join(' ')
  end

  def metadata
    @raw_fingerprint["metadata"]
  end

  [:artist, :title, :release, :genre].each do |meta_info|
    define_method(meta_info) { metadata[meta_info.to_s]}
  end

  def version
    metadata['version']
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

    first_timestamp = @offsets[1]

    sixty_seconds = (60.0 * 1000.0 / 23.2 + first_timestamp).to_i
    timestamps = terms = []

    @offsets.each_with_index do |timestamp, index|
      if timestamp <= sixty_seconds
        timestamps << timestamp
        terms << index
      end
    end

    @offsets, @terms = timestamps, terms

  end

  private

  def extract_compressed_data_string
    @compressed_data_string = @raw_fingerprint['code'].encode("utf-8")
  end

  def decompress_compressed_data_string
    return "" if @compressed_data_string.blank?
    @decompressed_data_string = Zlib::Inflate.inflate(Base64.urlsafe_decode64(@compressed_data_string))
  end

  def parse_decompressed_data_string
    if @decompressed_data_string.nil?
      raise FingerprintError, 'decompressed string is nil'
    end
    # Takes an uncompressed data string consisting of 0-padded fixed-width
    # sorted hex and converts it to the standard code string."""
    n = (@decompressed_data_string.length / 10.0).to_i

    end_timestamps_position = n*5  # 5 hex bytes for hash, 5 hex bytes for time (40 bits)
                                   # Parse out n groups of 5 timestamps in hex; then n groups of 8 hash codes in hex.
    raw_timestamps = @decompressed_data_string[0...end_timestamps_position]
    raw_codes = @decompressed_data_string[end_timestamps_position..-1]

    @offsets = chunker(raw_timestamps, 5).map{|el| el.join('').to_i(16)}
    @terms = chunker(raw_codes, 5).map{|el| el.join('').to_i(16)}
  end

  def chunker(seq, size)
    seq.split('').each_slice(size).to_a
  end

end