class Track < ActiveRecord::Base
  attr_accessible :track_file
  mount_uploader :track_file, TrackUploader

  after_create :add_to_solr

  def add_to_solr
    fingerprint = Fingerprint.new track_file.file.file
    raw_fingerprint = fingerprint.raw_fingerprint
    code = raw_fingerprint["code"]
    m = raw_fingerprint["metadata"]
    trid = Digest::MD5.hexdigest(Time.now.to_s(:db)+rand(100000).to_s)
    length = m["duration"]
    version = m["version"]
    artist = m["artist"]
    title = m["title"]
    release = m["release"]
    data = {
            "fp" => fingerprint.solr_string,
            "track_id" => trid,
            "length" => length,
            "codever" => "2.2"
    }
    data['artist'] = artist unless artist.blank?
    data['title'] = title unless title.blank?
    data['release'] = release unless release.blank?

    data

    split_prints = split_codes(data)
    solr = RSolr.connect :url => 'http://localhost:8502/solr/fp'
    solr.add split_prints
    solr.commit
  end

  def split_codes fp
    #Split a codestring into a list of codestrings. Each string contains
    #    at most 60 seconds of codes, and codes overlap every 30 seconds. Given a
    #    track id, return track ids of the form trid-0, trid-1, trid-2, etc.

    # Convert seconds into time units
    segmentlength = 60 * 1000.0 / 23.2
    halfsegment = segmentlength / 2.0

    trid = fp["track_id"]
    codestring = fp["fp"]
    codes = codestring.split(' ')
    pairs = chunker(codes, 2)
    pairs = pairs.map{|el| [el[1].to_i, el.join(' ')]}
    pairs = pairs.sort
    size = pairs.count

    numsegs = 0
    if pairs.count > 0
      lasttime = pairs[-1][0]
      numsegs = (lasttime / halfsegment).to_i + 1
    end

    ret = []
    sindex = 0
    numsegs
    pairs[0]
    0.upto(numsegs-1) do |i|
      s = i * halfsegment
      e = i * halfsegment + segmentlength

      #[s,e]

      while sindex < size and pairs[sindex][0] < s do
        #print "s", sindex, l[sindex]
        sindex+=1
      end
      eindex = sindex

      while eindex < size and pairs[eindex][0] < e do
        #print "e",eindex,l[eindex]
        eindex+=1
      end

      key = "#{trid}-#{i}"


      segment = {"track_id"=> key,
                 "fp" => pairs[sindex..eindex].map{|p| p[1]}.join(' '),
                 "length"=> fp["length"],
                 'source' => 'local',
                 'import_date' => Time.now.strftime("%Y-%m-%dT%H:%M:%SZ"),
                 "codever"=> fp["codever"]}
      ["artist", 'release', 'track', 'source', 'import_date'].each do |key|
        segment[key] = fp[key] if fp.has_key?(key)
      end
      ret << segment
    end
    ret
  end

  def chunker(seq, size)
    seq.each_slice(size).to_a
  end

end
