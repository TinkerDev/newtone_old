class Track < ActiveRecord::Base
  attr_accessible :track_file
  mount_uploader :track_file, TrackUploader

  after_create :add_to_solr

  def add_to_solr
    recognition = Recognition.new track_file.file.file
    recognition.common_parse_flow
    raw_fingerprint = recognition.raw_fingerprint
    code = raw_fingerprint["code"]
    m = raw_fingerprint["metadata"]
    trid = 'TRLJNAF13D75CE63E1-0'
    length = m["duration"]
    version = m["version"]
    artist = m["artist"]
    title = m["title"]
    release = m["release"]
    data = {"track_id" => trid,
      "fp" => recognition.solr_final_string,
      "length" => length,
      "codever" => "2.2"
    }

    #split_prints = split_codes(fprint)
    #docs.extend(split_prints)
    #codes.extend(((c["track_id"].encode("utf-8"), c["fp"].encode("utf-8")) for c in split_prints))



  end
end
